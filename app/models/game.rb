class Game < ApplicationRecord
    has_many :rounds
    has_many :players
    has_many :matchups, through: :rounds
end
