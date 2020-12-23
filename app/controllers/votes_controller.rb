class VotesController < ApplicationController
    def create
        vote = Vote.create(vote_params)
        render json: vote
    end

    private

    def vote_params
        params.permit(:voter_id, :matchup_id, :recipient_id)
    end
end
