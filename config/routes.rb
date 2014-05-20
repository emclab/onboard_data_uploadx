OnboardDataUploadx::Engine.routes.draw do
  
  resources :engine_configs do
    collection do
      get :search
      put :search_results  
    end
    
#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('engine_config_wf_route', 'onboard_data_uploadx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        put :submit
        put :test_pass
        put :test_reject
        put :review_pass
        put :review_reject
        put :commission
        put :decommission
        put :rewind        
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  
  resources :user_accesses do
    collection do
      get :search
      put :search_results  
    end
    
#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('user_access_wf_route', 'onboard_data_uploadx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        put :submit
        put :test_pass
        put :test_reject
        put :review_pass
        put :review_reject
        put :commission
        put :decommission
        put :rewind        
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end

  resources :engine_inits do
    collection do
      get :search
      put :search_results   
    end
    
#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('engine_init_wf_route', 'onboard_data_uploadx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        put :submit
        put :test_pass
        put :test_reject
        put :review_pass
        put :review_reject
        put :commission
        put :decommission
        put :rewind       
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  
  resources :search_stat_configs do
    collection do
      get :search
      put :search_results  
    end
    
#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('search_stat_config_wf_route', 'onboard_data_uploadx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        put :submit
        put :test_pass
        put :test_reject
        put :review_pass
        put :review_reject
        put :commission
        put :decommission
        put :rewind        
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  
end
