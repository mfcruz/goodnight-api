Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :users do
        resources :sleep_times do
          collection do
            post 'clock_in', to: 'sleep_times#clock_in'
          end
        end
      end
    end
  end
end
