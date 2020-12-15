class CreateBotResponses < ActiveRecord::Migration[6.0]
  def change
    create_table :bot_responses do |t|
      t.string :text

      t.timestamps
    end
  end
end
