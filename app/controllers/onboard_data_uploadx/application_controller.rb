module OnboardDataUploadx
  class ApplicationController < ApplicationController
    include Authentify::SessionsHelper
    include Authentify::AuthentifyUtility
    include Authentify::UsersHelper
    include Authentify::UserPrivilegeHelper
    include Commonx::CommonxHelper
    include Searchx::SearchHelper
    include BizWorkflowx::WfHelper
    
    before_filter :require_signin
    before_filter :set_locale
    before_filter :max_pagination 
    before_filter :check_access_right 
    before_filter :load_session_variable, :only => [:new, :edit]  #for parent_record_id & parent_resource in check_access_right
    after_filter :delete_session_variable, :only => [:create, :update]   #for parent_record_id & parent_resource in check_access_right
    before_filter :view_in_config?
    
    protected
  
    def max_pagination
      @max_pagination = find_config_const('pagination')
    end
    
    def view_in_config?
      @view_in_config = Authentify::AuthentifyUtility.load_view_in_config
    end
    
    #engine's
    def engine_boarded(models)
      engine_boarded = ''
      models.each do |r|
        engine = OnboardDatax.engine_class.find_by_id(r.engine_id)
        engine_boarded += ' ' + engine.name unless engine_boarded.include?(engine.name)
      end
      return engine_boarded, models.uniq.pluck('engine_id').size
    end
  end
end
