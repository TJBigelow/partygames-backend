class GameSerializer < ActiveModel::Serializer
  attributes :id, :code, :started, :players, :rounds, :matchups
end
