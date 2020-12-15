class Player < ApplicationRecord
  belongs_to :game

  def matchups
    Matchup.where("player1_id = ? OR player2_id = ?", self.id, self.id)
  end
end
