class Vote < ApplicationRecord
    belongs_to :voter, :class_name => 'Player'
    belongs_to :recipient, :class_name => 'Player'
    belongs_to :matchup
end
