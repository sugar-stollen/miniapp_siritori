class Game < ApplicationRecord
  has_many :words, dependent: :destroy
end
