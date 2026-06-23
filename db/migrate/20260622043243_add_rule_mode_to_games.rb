class AddRuleModeToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :start_random, :boolean, default: false
    add_column :games, :longer_word, :boolean, default: false
  end
end