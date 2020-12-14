class CreateMatchups < ActiveRecord::Migration[6.0]
  def change
    create_table :matchups do |t|
      t.integer :player1_id
      t.integer :player2_id
      t.string :player1_response
      t.string :player2_response
      t.string :prompt
      t.references :round, null: false, foreign_key: true

      t.timestamps
    end
  end
end
