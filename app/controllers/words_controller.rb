class WordsController < ApplicationController
  def index
    @game = current_game || Game.new

    @words =
      @game.persisted? ?
        @game.words.order(created_at: :asc) :
        []

    @total_score =
      @game.persisted? ?
        @game.words.sum(:score) :
        0

    @word = Word.new
  end
  
  def start_game
    return redirect_to(words_path) if current_game

    game = Game.new

    game.start_random = params[:start_random].present?
    game.longer_word = params[:longer_word].present?

    if game.start_random?
      game.start_char = ('あ'..'わ').to_a.sample
    end

    game.save!

    session[:game_id] = game.id

    redirect_to words_path
  end

  def create
     # 現在のゲームを取得（セッションやパラメータから）
       @game = current_game # または session[:game_id] など
        
       @word = @game.words.build(word_params)
    
    if @word.save
      redirect_to words_path
    else
      @words = @game.words.order(created_at: :asc)
      @total_score = Word.sum(:score) || 0
      render :index, status: :unprocessable_entity
     end
  end

 def reset
  Word.destroy_all

  session.delete(:game_id)

  redirect_to words_path
 end

  private
  
  def word_params
    params.require(:word).permit(:content)
  end

  # 現在のゲームを取得または新規作成
  def current_game
     @current_game ||= begin
      Game.find_by(id: session[:game_id])
    end
  end

  def create_new_game
    game = Game.create!
    session[:game_id] = game.id
    game
  end
end
