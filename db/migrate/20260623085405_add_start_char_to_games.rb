class AddStartCharToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :start_char, :string
  end
end
