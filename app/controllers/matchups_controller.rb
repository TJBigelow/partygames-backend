class MatchupsController < ApplicationController

    def index
        matchups = Matchup.all
        render json: matchups
    end
end
