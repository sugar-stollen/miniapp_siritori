class AddScoreToWords < ActiveRecord::Migration[7.0]
  def change
    add_column :words, :score, :integer, default: 0
  end
end