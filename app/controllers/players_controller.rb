class PlayersController < ApplicationController
    def index
        players = Player.all
        render json: players
    end


    def show
        player = Player.find(params[:id])
        render json: player
    end

    def create
        game = Game.find_by(code: player_params[:game])
        player = game.players.new(username: player_params[:username]) unless game.started
        if player.save
            GamesChannel.broadcast_to( game, {
                # id: game.id,
                # code: game.code,
                players: game.players,
                # started: game.started,
                # active_phase: game.active_phase,
                # timer: game.timer,
            })
        end
        render json: player
    end

    private

    def player_params
        params.permit(:game, :username)
    end
end
