class Player < ApplicationRecord
  belongs_to :game
  has_many :votes, :foreign_key => "voter_id"
  has_many :votes_received, :foreign_key => "recipient_id", :class_name => 'Vote'

  validates :username, uniqueness: {scope: :game, message: "is taken"}

  def matchups
    Matchup.where("player1_id = ? OR player2_id = ?", self.id, self.id)
  end

  def score
    self.votes_received.count
  end
end
