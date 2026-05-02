Rails.application.routes.draw do
    resources :words do
    collection do
      delete :reset  # リセット機能用
    end
  end
  
  root 'words#index'  # トップページの設定
end
