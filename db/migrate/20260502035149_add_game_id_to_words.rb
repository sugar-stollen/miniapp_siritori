class AddGameIdToWords < ActiveRecord::Migration[7.0]
  def change
    add_column :words, :game_id, :integer
  end
end
