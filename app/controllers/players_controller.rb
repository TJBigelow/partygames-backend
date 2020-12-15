class PlayersController < ApplicationController
    def index
        players = Player.all
        render json: players
    end

    def create
        game = Game.find_by(code: params[:game])
        player = game.players.new(username: params[:username])
        if player.save
            GamesChannel.broadcast_to( game, {
                code: game.code,
                players: game.players
            })
        end
        render json: player
    end
end
