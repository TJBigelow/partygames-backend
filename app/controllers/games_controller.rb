class GamesController < ApplicationController
    require 'faker'

    def index
        games = Game.all
        render json: games
    end

    def show
        game = Game.find(params[:id])
        render json: game
    end

    def create
        unless params[:game]
            code = Array.new(4) { Array('A'..'Z').sample }.join
            game = Game.create(code: code)
            render json: game
        else
            game = Game.find_by(code: params[:game])
            players = game.players.to_a
            if players.length < 4
                (4 - players.length).times do
                    players << game.players.create(username: "Bot " + Faker::Name.unique.first_name, isbot: true)          
                end
            end
            players << game.players.create(username: "Bot " + Faker::Name.unique.first_name, isbot: true) if players.length.odd?          
            prompts = Prompt.all.sample(players.length / 2 * 3)
            prompt_index = 0
            fixed_player = players.shuffle!.pop
            3.times do |i|
                round = game.rounds.create(round_number: i+1)
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
            game.update(started: true)
            render json: game
        end
    end
end