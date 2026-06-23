Rails.application.routes.draw do
    resources :words do
    collection do
      post :start_game
      delete :reset  # リセット機能用
    end
  end
  
  root 'words#index'  # トップページの設定
end
