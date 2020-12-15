class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :username, :isbot, :matchups, :game
end
