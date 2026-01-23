Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  get "about", controller: :static_pages
  resources :colours, only: [ :new, :create ]
  get "contact", controller: :static_pages
  resources :languages, only: [ :new, :create ]
  match "match" => "match#index", via: [ :get ]
  resources :organisations do
    collection do
      get "autocomplete"
    end
    member do
      post "geolocate"
    end
    resource :plaques, controller: :organisation_plaques, only: :show
    match "plaques/:filter" => "organisation_plaques#show", via: [ :get ]
  end
  resources :pages
  scope "/people" do
    resources "a-z", controller: :people_by_index, as: "people_by_index", only: :show
  end
  resources :people do
    collection do
      get "autocomplete"
    end
    member do
      post "geolocate"
    end
    resource :plaques, controller: :person_plaques, only: :show
    resource :roles, controller: :person_roles, only: :show
  end
  resources :personal_roles
  resources :places, controller: :countries, as: :countries do
    collection do
      get "autocomplete", controller: :areas
    end
    resources :areas do
      member do
        post "geolocate"
      end
      resource :plaques, controller: :area_plaques, only: :show
      resource :subjects, controller: :area_subjects, only: :show
      match "plaques/:filter" => "area_plaques#show", via: [ :get ]
    end
    resource :plaques, controller: :country_plaques, only: :show
    resource :subjects, controller: :country_subjects, only: :show
    match "plaques/:filter" => "country_plaques#show", via: [ :get ]
  end
  scope "/plaques" do
    resource :latest, as: :latest, controller: :plaques_latest, only: :show
  end
  resources :plaques do
    resource :colour, controller: :plaque_colour, only: :edit
    resources :connections, controller: :personal_connections, as: :connections
    resource :description, controller: :plaque_description, only: [ :edit, :show ]
    resource :geolocation, controller: :plaque_geolocation, only: :edit
    member do
      post "flickr_search"
      get "flickr_search_all"
    end
    resource :inscription, controller: :plaque_inscription, only: :edit
    resource :language, controller: :plaque_language, only: :edit
    resource :location, controller: :plaque_location, only: :edit
    resource :photos, controller: :plaque_photos, only: :show
    resource :series, controller: :plaque_series, only: :edit
    resources :sponsorships
    resource :talk, controller: :plaque_talk, only: :create
  end
  # map tiles are numbered using the convention at http://wiki.openstreetmap.org/wiki/Slippy_map_tilenames
  match "plaques/tiles/:zoom/:x/:y" => "plaques#index", constraints: { zoom: /\d{2}/, x: /\d+/, y: /\d+/ }, via: [ :get ]
  match "plaques/:filter/tiles/:zoom/:x/:y" => "plaques#index", id: :filter, constraints: { zoom: /\d{2}/, x: /\d+/, y: /\d+/ }, via: [ :get ]
  resources :photos, only: [ :create, :destroy, :edit, :new, :show, :update ]
  resources :photographers, as: :photographers, only: [ :create, :index, :new ]
  scope "/roles" do
    resources "a-z", controller: :roles_by_index, as: "roles_by_index", only: [ :show, :index ]
    resources "precedence", controller: :roles_by_precedence, as: "roles_by_precedence", only: [ :index ]
  end
  resources :roles do
    collection do
      get "autocomplete"
    end
  end
  match "search" => "search#index", via: [ :get ]
  match "search/:phrase" => "search#index", via: [ :get ]
  resources :series do
    collection do
      get "autocomplete"
    end
    member do
      post "geolocate"
    end
    resource :plaques, controller: :series_plaques, only: :show
  end
  get "series/:id/:series_ref", to: "series#show"
  scope "/subjects" do
    resources "a-z", controller: :people_by_index, as: "people_by_index", only: :show
  end
  resources :todo
  devise_for :users,
            controllers: {
              class: "User",
              registrations: "registrations",
              omniauth_callbacks: "accounts/omniauth_callbacks"
            }
  # resources :users, controller: 'accounts/users', only: %i[index show update] do
  #   get :notifications
  # end
  resources :verbs, only: [ :create, :index, :show, :new ] do
    collection do
      get "autocomplete"
    end
  end
  scope "/women" do
    resources "a-z", controller: :women_by_index, as: "women_by_index", only: :show
  end
  get "*", to: "pages#show"
end
