class Word < ApplicationRecord
validates :content, presence: true

  validate :cannot_end_with_n
  validate :must_start_with_last_character

  private

  def cannot_end_with_n
    if content.present? && content[-1] == 'ん'
      errors.add(:content, 'は「ん」で終わることはできません')
    end
  end

  def must_start_with_last_character
    return if Word.count.zero? # 最初の単語はチェック不要

    last_word = Word.order(:position).last
    if last_word && content.present? && content[0] != last_word.content[-1]
      errors.add(:content, "は「#{last_word.content[-1]}」で始まる必要があります")
    end
  end
end
