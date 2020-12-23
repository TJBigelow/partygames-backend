class VoteSerializer < ActiveModel::Serializer
  attributes :id, :voter_id, :matchup_id, :recipient_id
end
