Sinesss::Application.routes.draw do
  match '/bitacoras/:tipo', to:'bitacoras#index', as: 'tipo_bitacora', via: 'get'
  resources :bitacoras, :only => :index

  match '/bases/import', to:'bases#import', as: 'bases_import', via: 'get'
  match '/bases/importar', to:'bases#importar', as: 'bases_importar', via: 'post'
  match '/bases/import_juntas', to:'bases#import_juntas', as: 'bases_import_juntas', via: 'get'
  match '/bases/importar_juntas', to:'bases#importar_juntas', as: 'bases_importar_juntas', via: 'post'
  resources :bases do
    match '/miembros', to:'bases#miembros', as: 'miembros', via: 'get'
    match '/new_junta', to:'juntas#new', as: 'new_junta', via: 'get'
    match '/crear_junta', to:'juntas#create', as: 'create_junta', via: 'post'
    match '/edit_junta/:junta_id', to:'juntas#edit', as: 'edit_junta', via: 'get'
    match '/editar_junta/:junta_id', to:'juntas#update', as: 'editar_junta', via: 'patch'
    match '/destruir_junta/:junta_id', to:'juntas#destroy', as: 'destroy_junta', via: 'delete'
  end

  match '/enfermeras/import_data_actualizada', to:'enfermeras#import_data_actualizada', as: 'enfermeras_import_data_actualizada', via: 'get'
  match '/enfermeras/importar_data_actualizada', to:'enfermeras#importar_data_actualizada', as: 'enfermeras_importar_data_actualizada', via: 'post'
  match '/enfermeras/import_essalud', to:'enfermeras#import_essalud', as: 'enfermeras_import_essalud', via: 'get'
  match '/enfermeras/importar_essalud', to:'enfermeras#importar_essalud', as: 'enfermeras_importar_essalud', via: 'post'
  resources :enfermeras do
    match '/bitacoras', to:'enfermeras#bitacoras', as: 'bitacoras', via: 'get'
    resources :bitacoras, :only => [:new, :create] do
      match '/status', to:'bitacoras#change_status', as: 'change_status', via: 'post'
    end
  end

  match '/entes/import', to:'entes#import', as: 'entes_import', via: 'get'

  match '/entes/importar', to:'entes#importar', as: 'entes_importar', via: 'post'
  resources :entes do
    match '/enfermeras', to:'entes#enfermeras', as: 'enfermeras', via: 'get'
  end


  get '/red_asistencials/import', to:'red_asistencials#import', as: 'red_asistencial_import'
  post '/red_asistencials/importar', to:'red_asistencials#importar', as: 'red_asistencial_importar'
  resources :red_asistencials, :except => :show do
    match '/entes', to:'red_asistencials#entes', as: 'entes', via: 'get'
  end
  
  resources :imports, :only => [:index, :destroy] do
    match '/download', to:'imports#download', as: 'download', via: 'get'
  end

  get "/dashboard", to: 'home#dashboard'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root :to => redirect("/dashboard")

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
