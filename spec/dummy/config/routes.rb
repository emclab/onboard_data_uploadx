Rails.application.routes.draw do

  mount OnboardDataUploadx::Engine => "/onboard_data_uploadx"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Searchx::Engine => '/searchx'
  mount StateMachineLogx::Engine => '/sm_log'
  mount BizWorkflowx::Engine => '/biz_wf'
  mount SwModuleInfox::Engine => '/sw_module'
  mount ResourceAllocx::Engine => '/res_alloc'
  mount InfoServiceProjectx::Engine => '/project'
  mount Kustomerx::Engine => '/customer'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
