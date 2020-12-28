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
        code = Array.new(4) { Array('A'..'Z').sample }.join
        game = Game.create(code: code)
        render json: game
    end

    def start
        game = Game.find(params[:id])
        unless game.started
            game.create_matchups
            game.update(started: true)
            game.run_game
        else
            render json: {error: 'Game has already started'}
        end
    end

    def watch
        game = Game.find_by(code: params[:code])
        render json: game
    end
end