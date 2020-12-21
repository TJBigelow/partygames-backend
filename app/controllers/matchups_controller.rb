class MatchupsController < ApplicationController

    def index
        matchups = Matchup.all
        render json: matchups
    end

    def show
        matchup = Matchup.find(params[:id])
        render json: matchup
    end

    def update
        matchup = Matchup.find(params[:id])
        matchup.update(matchup_params)
    end

    private

    def matchup_params
        params.permit(:id, :player1_response, :player2_response)
    end
end
