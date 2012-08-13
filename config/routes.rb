AllRightAction::Application.routes.draw do
  get "users/update"

  get "users/index"

  get "users/show"

  get "images/index"

  get "images/create"

  get "map_entries/index"

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :users => "users/sessions" }
  resources :comments, :chat_messages, :news_entries, :map_entries, :images, :albums, :users
  match 'switch_albums' => "albums#switch", :as => :switch_albums, :via => :put
  match 'switch_images' => "images#switch", :as => :switch_images, :via => :put
  match 'news_update' => "news_entries#index_x", :as => :news_update, :via => :get
  match 'aws_policy' => "application#aws_policy", :as => :aws_policy, :via => :get
  match 'avatars/:id' => "albums#avatar", :as => :avatars, :via => :get
  match 'set_avatar' => "users#set_avatar", :as => :set_avatar, :via => :put
  match 'set_description' => "users#set_description", :as => :set_description, :via => :put
  match 'toggle_friendship' => "users#toggle_friendship", :as => :toggle_friendship, :via => :put
  match 'settings' => "users#settings", :as => :settings, :via => :get
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
#== Route Map
# Generated on 21 Jul 2012 00:08
#
#            images_create GET    /images/create(.:format)               images#create
#        map_entries_index GET    /map_entries/index(.:format)           map_entries#index
#         new_user_session GET    /users/sign_in(.:format)               devise/sessions#new
#             user_session POST   /users/sign_in(.:format)               devise/sessions#create
#     destroy_user_session DELETE /users/sign_out(.:format)              devise/sessions#destroy
#  user_omniauth_authorize        /users/auth/:provider(.:format)        users/omniauth_callbacks#passthru {:provider=>/facebook|vkontakte/}
#   user_omniauth_callback        /users/auth/:action/callback(.:format) users/omniauth_callbacks#(?-mix:facebook|vkontakte)
#            user_password POST   /users/password(.:format)              devise/passwords#create
#        new_user_password GET    /users/password/new(.:format)          devise/passwords#new
#       edit_user_password GET    /users/password/edit(.:format)         devise/passwords#edit
#                          PUT    /users/password(.:format)              devise/passwords#update
# cancel_user_registration GET    /users/cancel(.:format)                devise/registrations#cancel
#        user_registration POST   /users(.:format)                       devise/registrations#create
#    new_user_registration GET    /users/sign_up(.:format)               devise/registrations#new
#   edit_user_registration GET    /users/edit(.:format)                  devise/registrations#edit
#                          PUT    /users(.:format)                       devise/registrations#update
#                          DELETE /users(.:format)                       devise/registrations#destroy
#              user_unlock POST   /users/unlock(.:format)                devise/unlocks#create
#          new_user_unlock GET    /users/unlock/new(.:format)            devise/unlocks#new
#                          GET    /users/unlock(.:format)                devise/unlocks#show
#                 comments GET    /comments(.:format)                    comments#index
#                          POST   /comments(.:format)                    comments#create
#              new_comment GET    /comments/new(.:format)                comments#new
#             edit_comment GET    /comments/:id/edit(.:format)           comments#edit
#                  comment GET    /comments/:id(.:format)                comments#show
#                          PUT    /comments/:id(.:format)                comments#update
#                          DELETE /comments/:id(.:format)                comments#destroy
#            chat_messages GET    /chat_messages(.:format)               chat_messages#index
#                          POST   /chat_messages(.:format)               chat_messages#create
#         new_chat_message GET    /chat_messages/new(.:format)           chat_messages#new
#        edit_chat_message GET    /chat_messages/:id/edit(.:format)      chat_messages#edit
#             chat_message GET    /chat_messages/:id(.:format)           chat_messages#show
#                          PUT    /chat_messages/:id(.:format)           chat_messages#update
#                          DELETE /chat_messages/:id(.:format)           chat_messages#destroy
#             news_entries GET    /news_entries(.:format)                news_entries#index
#                          POST   /news_entries(.:format)                news_entries#create
#           new_news_entry GET    /news_entries/new(.:format)            news_entries#new
#          edit_news_entry GET    /news_entries/:id/edit(.:format)       news_entries#edit
#               news_entry GET    /news_entries/:id(.:format)            news_entries#show
#                          PUT    /news_entries/:id(.:format)            news_entries#update
#                          DELETE /news_entries/:id(.:format)            news_entries#destroy
#              map_entries GET    /map_entries(.:format)                 map_entries#index
#                          POST   /map_entries(.:format)                 map_entries#create
#            new_map_entry GET    /map_entries/new(.:format)             map_entries#new
#           edit_map_entry GET    /map_entries/:id/edit(.:format)        map_entries#edit
#                map_entry GET    /map_entries/:id(.:format)             map_entries#show
#                          PUT    /map_entries/:id(.:format)             map_entries#update
#                          DELETE /map_entries/:id(.:format)             map_entries#destroy
#                   images GET    /images(.:format)                      images#index
#                          POST   /images(.:format)                      images#create
#                new_image GET    /images/new(.:format)                  images#new
#               edit_image GET    /images/:id/edit(.:format)             images#edit
#                    image GET    /images/:id(.:format)                  images#show
#                          PUT    /images/:id(.:format)                  images#update
#                          DELETE /images/:id(.:format)                  images#destroy
#                   albums GET    /albums(.:format)                      albums#index
#                          POST   /albums(.:format)                      albums#create
#                new_album GET    /albums/new(.:format)                  albums#new
#               edit_album GET    /albums/:id/edit(.:format)             albums#edit
#                    album GET    /albums/:id(.:format)                  albums#show
#                          PUT    /albums/:id(.:format)                  albums#update
#                          DELETE /albums/:id(.:format)                  albums#destroy
#            switch_albums PUT    /switch_albums(.:format)               albums#switch
#            switch_images PUT    /switch_images(.:format)               images#switch
#              news_update GET    /news_update(.:format)                 news_entries#index_x
#               aws_policy GET    /aws_policy(.:format)                  application#aws_policy
#                     root        /                                      home#index
