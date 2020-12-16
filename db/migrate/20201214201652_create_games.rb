class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :code
      t.boolean :started, :default => false
      t.string :active_phase
      t.integer :timer, :default => 0

      t.timestamps
    end
  end
end
