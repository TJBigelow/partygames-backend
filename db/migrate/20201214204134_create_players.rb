class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :username
      t.references :game, null: false, foreign_key: true
      t.boolean :isbot, :default => false

      t.timestamps
    end
  end
end
