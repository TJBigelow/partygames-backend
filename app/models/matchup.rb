class Matchup < ApplicationRecord
  belongs_to :round

  belongs_to :player1, class_name: 'Player'
  belongs_to :player2, class_name: 'Player'
end
