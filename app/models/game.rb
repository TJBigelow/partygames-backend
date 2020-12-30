class Game < ApplicationRecord
    has_many :rounds, :dependent => :delete_all
    has_many :players, :dependent => :delete_all
    has_many :matchups, through: :rounds

    validates :code, uniqueness: true

    def create_matchups
        players = self.players.to_a
        if players.length < 4
            (4 - players.length).times do
                players << self.players.create(username: "Bot " + Faker::Name.unique.first_name, isbot: true)          
            end
        end
        players << self.players.create(username: "Bot " + Faker::Name.unique.first_name, isbot: true) if players.length.odd?          
        prompts = Prompt.all.sample(players.length / 2 * 3)
        prompt_index = 0
        fixed_player = players.shuffle!.pop
        3.times do |i|
            round = self.rounds.create(round_number: i+1)
            two_rows = [[fixed_player]+players[0..players.size/2-1], players[players.size/2..-1].reverse]
            pairs = two_rows.transpose.shuffle # the shuffle is optional, just cosmetic
            pairs.each do |pair|
                p1resp = '' 
                p2resp = '' 
                p1resp = BotResponse.all.sample.text if pair[0].isbot 
                p2resp = BotResponse.all.sample.text if pair[1].isbot 
                mu = round.matchups.create(player1: pair[0], player2:pair[1], prompt: prompts[prompt_index]['text'], player1_response: p1resp, player2_response: p2resp)
                prompt_index += 1
            end
            players.rotate!
        end
    end

    def run_game
        self.update(active_phase: 'starting')
        GamesChannel.broadcast_to( self, { 
            players: self.players,
            started: self.started
        })
        self.set_timer(duration: 5)
        self.start_game
        self.round(1)
        self.set_timer(duration: 30)
        self.round_voting(1)
        self.score_recap
        self.set_timer(duration: 10, round_number: 1)
        self.round(2)
        self.set_timer(duration: 30)
        self.round_voting(2)
        self.score_recap
        self.set_timer(duration: 10, round_number: 2)
        self.round(3)
        self.set_timer(duration: 30)
        self.round_voting(3)
        self.score_recap
        self.set_timer(duration: 10, round_number: 3)
        # self.destroy
    end

    def start_game
        self.players.each do |player|
            PlayersChannel.broadcast_to( player, {
                active_phase: self.active_phase,
                message: 'The game has begun'
            })
        end
    end

    def round (round_number)
        self.update(active_phase: "submissions")
        GamesChannel.broadcast_to( self, {
            active_phase: self.active_phase,
            round: round_number,
        })
        self.players.each do |player|
            matchup = player.matchups.find{|matchup| matchup.round.round_number == round_number}
            prompt = matchup.prompt
            player_number =  matchup.player1 == player ? 'player1' : 'player2'
            PlayersChannel.broadcast_to( player, { active_phase: self.active_phase, prompt: prompt, matchup: matchup.id, player_number: player_number, round_number: round_number})
        end
    end

    def round_voting (round_number) 
        round = self.rounds.find_by(round_number: round_number)
        round.matchups.each do |matchup|
            self.update(active_phase: "voting")
            self.matchup_voting(matchup, round_number)
            self.update(active_phase: "recap")
            self.matchup_recap(matchup, round_number)
        end
    end

    def matchup_voting(matchup, round_number)
        self.players.each do |player|
            if player.matchups.include?(matchup)
                PlayersChannel.broadcast_to( player, {
                    active_phase: "self vote",
                    message: "You can't vote for yourself"
                })
            else
                PlayersChannel.broadcast_to( player, {
                    active_phase: self.active_phase,
                    matchup: matchup,
                    voter_id: player.id
                })
            end
        end
        GamesChannel.broadcast_to( self, {
            active_phase: self.active_phase,
            round: round_number,
            matchup: matchup,
        })
        self.set_timer(duration: 30, round_number: round_number, matchup: matchup)
    end

    def matchup_recap(matchup, round_number)
        self.players.each do |player|
            PlayersChannel.broadcast_to( player, {
                active_phase: self.active_phase,
                message: "Wait for next matchup"
            })
        end
        GamesChannel.broadcast_to( self, {
            active_phase: self.active_phase,
            round: round_number,
            matchup: matchup,
            player1_votes: matchup.votes.count{|vote| vote.recipient_id === matchup.player1_id},
            player2_votes: matchup.votes.count{|vote| vote.recipient_id === matchup.player2_id},
        })
        self.set_timer(duration: 10, round_number: round_number, matchup: matchup)
    end

    def score_recap
        self.update(active_phase: 'score')
        GamesChannel.broadcast_to( self, {
            active_phase: self.active_phase,
            players: self.players.map {|player| {id: player.id, username: player.username, score: player.score, isbot: player.isbot}},
        })
    end

    def set_timer (duration:, round_number: nil, matchup: nil)
        self.update(timer: duration + 1)
        while timer > 0
            GamesChannel.broadcast_to( self, {
                active_phase: self.active_phase,
                timer: self.timer-1,
                round: round_number,
                matchup: matchup,
            })
            self.update(timer: (timer-1))
            sleep(1) unless self.timer === 0
        end
    end
end
