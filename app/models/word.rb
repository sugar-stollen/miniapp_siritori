class Word < ApplicationRecord
  belongs_to :game  # ゲームとの関連付け

  # バリデーション（データのルール）
  validate :game_not_finished
  validate :starts_with_last_character  # 前の文字と繋がっているかチェック
  validate :does_not_end_with_n         # 「ん」で終わっていないかチェック
  validate :only_japanese_kana          #ひらがな・カタカナのみ入力可能
  validates :content, presence: true, uniqueness: { message: 'この単語はすでに使われています' } 
   #同じ単語を使えないようにする
   # スコア計算などのメソッド
  before_create :calculate_score
  
  # しりとりの次の文字を取得するメソッド（小文字を大文字に変換）
  def last_char_for_shiritori
    content[-1]
  end
    
  private
   # ゲームが終了していないかチェック
  def game_not_finished
   return if game.nil?
    
    # 10単語に達している場合はエラー
    if game.words.count >= 10
      errors.add(:base, '10単語入力済みです。「もう一度遊ぶ」を押してね')
    end
  end

  # しりとりのルール：前の単語の最後の文字で始まっているかチェック
  def starts_with_last_character
    return if game.words.count.zero?  # そのゲームの最初の単語ならチェック不要
    
    last_word = game.words.order(created_at: :desc).first
    current_first = normalize_character(content[0])
    #伸ばし棒と小文字のルールついか
    last_char = get_last_char_for_shiritori(last_word.content)
    
    unless current_first == last_char
      errors.add(:content, "前の単語の最後の文字（#{last_char}）で始めてください")
    end
  end

   # ひらがな・カタカナのみ許可
  def only_japanese_kana
   return if content.blank?

    unless content.match?(/\A[ぁ-んァ-ヶー]+\z/)
    errors.add(:content, 'ひらがな・カタカナのみ入力できます')
    end
  end

  # しりとりのルール：「ん」で終わる単語は使えない
  def does_not_end_with_n
    return if content.blank?
    last_char = content[-1]
    
    # カタカナの「ン」もチェック
    if last_char == 'ん' || last_char == 'ン'
      errors.add(:content, "「ん」で終わる単語は使えません")
    end
  end

    # 伸ばし棒と小文字のルールを適用して、しりとりで使う最後の文字を取得
  def get_last_char_for_shiritori(word)
    return nil if word.blank?
    
    last_char = word[-1]
    
    # 最後の文字が伸ばし棒なら、一文字前を使う
    if last_char == 'ー'
      # 一文字前が存在する場合はそれを使う、なければ伸ばし棒をそのまま使う
      last_char = word[-2] if word.length >= 2
    end
    
     # 小文字を大文字に変換（しゃ→や、きゅ→ゆ など）
    last_char = convert_small_to_large(last_char)

    # 正規化して返す
    normalize_character(last_char)
  end
  
  # 小文字を大文字に変換
  def convert_small_to_large(char)
    small_to_large = {
      'ぁ' => 'あ', 'ぃ' => 'い', 'ぅ' => 'う', 'ぇ' => 'え', 'ぉ' => 'お',
      'ゃ' => 'や', 'ゅ' => 'ゆ', 'ょ' => 'よ',
      'ゎ' => 'わ', 'っ' => 'つ',
      # カタカナも追加
      'ァ' => 'ア', 'ィ' => 'イ', 'ゥ' => 'ウ', 'ェ' => 'エ', 'ォ' => 'オ',
      'ャ' => 'ヤ', 'ュ' => 'ユ', 'ョ' => 'ヨ',
      'ヮ' => 'ワ', 'ッ' => 'ツ'
    }
  
    small_to_large[char] || char
  end

 # 文字の正規化（カタカナ→ひらがな、濁点・半濁点を取り除く）
  def normalize_character(char)
    return nil if char.nil?
    
    # カタカナをひらがなに変換
    normalized = char.tr('ァ-ン', 'ぁ-ん')

    # 濁点・半濁点を取り除く
    normalized.tr('がぎぐげござじずぜぞだぢづでどばびぶべぼぱぴぷぺぽ',
                  'かきくけこさしすせそたちつてとはひふへほはひふへほ')
  end
  

    def calculate_score
       # スコア計算（後で追加する場合）
       base_score = content.length * 10
       self.score = base_score
    end
end