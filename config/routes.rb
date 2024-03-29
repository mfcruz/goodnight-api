Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create, :index] do
        post 'follow/:followee_id', to: 'users#follow', as: 'follow'
        delete 'unfollow/:followee_id', to: 'users#unfollow', as: 'unfollow'
        get 'followees/sleep_records', to: 'users#followees_sleep_records', as: 'followees_sleep_records'

        resources :sleep_times do
          collection do
            post "clock_in", to: "sleep_times#clock_in"
            patch "clock_out", to: "sleep_times#clock_out"
          end
        end
      end
    end
  end
end
