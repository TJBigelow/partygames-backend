class Game < ApplicationRecord
    has_many :rounds
    has_many :players
    has_many :matchups, through: :rounds

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

    def start_game
        self.update(timer: 6)
        while timer > 0
            GamesChannel.broadcast_to( self, {
                id: self.id,
                code: self.code,
                players: self.players,
                started: self.started,
                timer: self.timer-1
            })
            self.update(timer: (timer-1))
            sleep(1) unless self.timer === 0
        end
        self.players.each do |player|
            PlayersChannel.broadcast_to( player, {
                message: 'The game has begun'
            })
        end
    end
end
