class WordsController < ApplicationController
  def index
    # 現在のゲームを取得または新規作成
    @game = current_game
    @words = @game.words.order(created_at: :asc)
    @total_score = Word.sum(:score) || 0
    @word = Word.new
  end
  
  def start_game
    game = create_new_game
    
    game.update(
      start_random: params[:start_random] == "1",
      longer_word: params[:longer_word] == "1"
     )

   if game.start_random?
    game.update(
      start_char: ('あ'..'わ').to_a.sample
     )
   end
   game.save!
   redirect_to words_path
  end

  def create
     # 現在のゲームを取得（セッションやパラメータから）
       @game = current_game # または session[:game_id] など

     # 最初の単語入力時だけルール確定
       if @game.words.empty?
          @game.update(
            start_random: params[:start_random] == "1",
            longer_word: params[:longer_word] == "1"
            )
       end
        
        @word = @game.words.build(word_params)
    
    if @word.save
      #保存成功時の処理
      if Word.count >= 10
        redirect_to words_path, notice: "🎉 おめでとうございます！10個の単語をクリアしました！"
      else
        redirect_to words_path, notice: "#{@word.content}を追加しました！"
      end
    else
    # エラー時は index をレンダリング
     @words = @game.words.order(created_at: :asc)
     @total_score = Word.sum(:score) || 0
     render :index, status: :unprocessable_entity  # ← status を追加
    end
  end

  def reset
    Word.destroy_all
    redirect_to words_path, notice: 'New game'
  end
  
  private
  
  def word_params
    params.require(:word).permit(:content)
  end

  # 現在のゲームを取得または新規作成
  def current_game
    if session[:game_id]
      Game.find_by(id: session[:game_id]) || create_new_game
    else
      create_new_game
    end
  end

  def create_new_game
    game = Game.create!
    session[:game_id] = game.id
    game
  end
end
