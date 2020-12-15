class PlayersController < ApplicationController
    def index
        players = Player.all
        render json: players
    end

    def create
        game = Game.find_by(code: params[:game])
        player = game.players.create(username: params[:username])
        render json: player
    end
end
