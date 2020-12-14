class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :code
      t.boolean :started
      t.string :active_phase

      t.timestamps
    end
  end
end
