Midoconline::Application.routes.draw do
  
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
#  root to: "patients#index"
  root to: "home#index"
  
  get '/admin/login' => "home#login"
  
   ##################################API Start#########################
  resources :tokens,:only => [:create], defaults: {format: 'json'}
  post 'tokens/get_key' => 'tokens#get_key', defaults: {format: 'json'}
  get 'tokens/destroy_token' => 'tokens#destroy_token', defaults: {format: 'json'}
  get 'tokens/check_token' => 'tokens#check_token', defaults: {format: 'json'}
  post 'tokens/user_sign_up' => 'tokens#user_sign_up', defaults: {format: 'json'}
  post 'tokens/doctor_sign_up' => 'tokens#doctor_sign_up', defaults: {format: 'json'}
  post 'tokens/facebook_authentication' => 'tokens#facebook_authentication', defaults: {format: 'json'}
  post 'tokens/twitter_authentication' => 'tokens#twitter_authentication', defaults: {format: 'json'}
  get '/user_profile' => 'users#user_profile', defaults: {format: 'json'}
  get '/my_profile' => 'users#my_profile', defaults: {format: 'json'}
  get '/patient_history' => 'patients#patient_history', defaults: {format: 'json'}
  get '/doctor_history' => 'doctors#doctor_history', defaults: {format: 'json'}
  get '/edit_profile' => 'users#edit_profile', defaults: {format: 'json'}
  get '/edit_doctor_profile' => 'users#edit_doctor_profile', defaults: {format: 'json'}
  get '/settings' => 'users#settings', defaults: {format: 'json'}
  post '/forget_password_request' => 'users#forget_password_request', defaults: {format: 'json'}
  post '/change_password_request' => 'users#change_password_request', defaults: {format: 'json'}
  get '/user_search' => 'users#user_search', defaults: {format: 'json'}
  post '/challenge_user_guide_line' => 'users#challenge_user_guide_line', defaults: {format: 'json'}
  post '/update_settings' => 'users#update_settings', defaults: {format: 'json'}
  post '/save_card_details' => 'users#save_card_details', defaults: {format: 'json'}
  get '/card_details' => 'users#card_details', defaults: {format: 'json'}
  post '/verify_for_payment' => 'users#verify_for_payment', defaults: {format: 'json'}
  get '/view_doctors_list' => 'doctors#view_doctors_list', defaults: {format: 'json'}
  post '/charge_payment' => 'users#charge_payment', defaults: {format: 'json'}
  
  ##################################API end#########################
  
  get '/change_doctor_list' => "patients#change_doctor_list", :as => "change_doctor_list"
  post '/update_details' => 'users#update_details', :as => "update_details"
  post '/update_doctor_details' => 'users#update_doctor_details', :as => "update_doctor_details"
  post '/create_history' => 'video_chats#create_history', :as => "create_history"
  post '/update_web_call_history' => 'video_chats#update_web_call_history', :as => "update_web_call_history"

  get '/chat_history' => "chats#index", :as => "chat_history"
  get '/chat_history/:id' => "chats#show", :as => "show_chat_history"


  resources :tokens, :news_posts, :blogs
  resources :charges, :contacts
  resources :video_chats do
    member do
      post "update_history"
      post "update_call_history"
      get 'doctor_listing'
    end
    collection do
      get 'doctor_listing'
    end
  end
  resources :histories do
    member do
      post "update_paid_history"
    end
  end
  resources :home do
    collection do
      get "thank_you"
    end
  end
  resources :patients do
    collection do
      get 'landing'  
    end
    member do
      get 'profile'
      get 'history'
      get 'localization'
    end
  end
  resources :doctors do
    collection do
      get :pending_list
    end
    member do
      get :update_doctor_status
      get :delete_doctor
      get 'profile'
      get 'history'
      get 'localization'
    end
  end
  resources :users, :chats, :chat_messages, :specializations
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
