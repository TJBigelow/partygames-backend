class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :voter_id
      t.integer :matchup_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end
