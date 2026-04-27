class WordsController < ApplicationController
  def index
    @words = Word.order(:position)
    @word = Word.new
  end

  def create
    @word = Word.new(word_params)
    @word.position = Word.count + 1

    if @word.save
      redirect_to words_path
    else
      @words = Word.order(:position)
      render :index
    end
  end

  private

  def word_params
    params.require(:word).permit(:content)
  end
end