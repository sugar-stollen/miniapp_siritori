module ApplicationHelper
  def x_share_url(score)
    text = "しりとりゲームで#{score}点獲得しました！<https://siritori-game-9x3o.onrender.com/> #しりとりゲーム"

    "https://twitter.com/intent/tweet?text=#{CGI.escape(text)}"
  end
end