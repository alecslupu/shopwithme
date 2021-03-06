ShopWithMe::Application.routes.draw do

  devise_for :admins
  authenticate :admin do #replace admin_user(s) with whatever model your users are stored in.
    mount Resque::Server.new, :at => "/jobs"
    mount Split::Dashboard => '/split'
    mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  end

  

  resources :deals, :only => [ :index ] do 
    get 'page/:page', :action => :index, :on => :collection
    member do 
      match :visit
    end
  end

  resources :products, :only => [:index, :show] do 
    get 'page/:page', :action => :index, :on => :collection
    member do 
      match :visit
    end
  end


  resources :advertisers, :only => [ :index, :show ] do 
    get 'page/:page', :action => :index, :on => :collection
    get 'page/:page', :action => :show, :on => :member
  end 
  
  resources :brands, :only => [ :index, :show ] do 
    get 'page/:page', :action => :index, :on => :collection
    get 'page/:page', :action => :show, :on => :member
  end 

  resources :categories, :only => [ :show, :index ] do 
    get 'page/:page', :action => :index, :on => :collection
    get 'page/:page', :action => :show, :on => :member
  end 

  scope :path => :extensions do 
    scope :path => :chrome do 
      scope :path => :search do
        get :product, to: "search#chrome", :format => :json
      end
    end
  end
  match '(errors)/:status', to: 'error#show', constraints: {status: /\d{3}/}


  # get "brands/show"
  # get "brands/index"
  # resources :brands, :only => [:show, :index]
  # resources :products do 
  #   member do 
  #     get :visit
  #   end
  # end

  # resources :advertisers, :controller => :advertiser, :only => [ :show, :index ] do 
  #   member do 
  #     get 'category/:category_id', :action => :category, :as => 'category'
  #   end
  # end
  
  root :to => 'home#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
