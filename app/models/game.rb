class Game < ApplicationRecord
  has_many :words

  before_create :generate_start_char

  private

  def generate_start_char
    return unless start_random?

    chars = ('あ'..'わ').to_a

    self.start_char = chars.sample
  end
end