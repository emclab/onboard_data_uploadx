require 'spec_helper'

module OnboardDataUploadx
  describe SearchStatConfigsController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
    end
    
    before(:each) do
      #wf_common_action(from, to, event)
      wf = "def submit
          wf_common_action('initial_state', 'reviewing', 'submit')
        end   
        def review_reject
          wf_common_action('reviewing', 'initial_state', 'review_reject')
        end 
        def review_pass
          wf_common_action('reviewing', 'testing', 'review_pass')
        end
        def test_reject
          wf_common_action('testing', 'initial_state', 'test_reject')
        end 
        def test_pass
          wf_common_action('testing', 'commissioning', 'test_pass')
        end
        def commission
          wf_common_action('commissioning', 'commissioned', 'commission')
        end
        def decommission
          wf_common_action('commissioned', 'decommissioned', 'decommission')
        end 
        def rewind
          wf_common_action('commissioned', 'initial_state', 'rewind')
        end      
        "
      FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'user_access_wf_action_def', :argument_value => wf)
      str = 'decommissioned'
      FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'user_access_wf_final_state_string', :argument_value => str)
      
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      
      @sw_mod = FactoryGirl.create(:sw_module_infox_module_info)
      @sw_mod1 = FactoryGirl.create(:sw_module_infox_module_info, :name => 'a new name')
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns all user accesses" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::SearchStatConfig.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :engine_id => @sw_mod.id)
        q1 = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :config_desp => 'a new one', :engine_id => @sw_mod1.id)
        get 'index', {:use_route => :onboard_data_uploadx}
        assigns(:search_stat_configs).should =~ [q, q1]
      end
      
      it "should only return the config which belongs to en engine" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::SearchStatConfig.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :engine_id => @sw_mod.id)
        q1 = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :config_desp => '50', :engine_id => @sw_mod.id + 1)
        get 'index', {:use_route => :onboard_data_uploadx, :engine_id => @sw_mod.id}
        assigns(:search_stat_configs).should =~ [q]
      end
      
      it "should only return the config which belongs to resource_name" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::SearchStatConfig.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :engine_id => @sw_mod.id)
        q1 = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :config_desp => '50', :engine_id => @sw_mod.id + 1, :resource_name => 'a res name')
        get 'index', {:use_route => :onboard_data_uploadx, :resource_name => q.resource_name}
        assigns(:search_stat_configs).should =~ [q]
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :onboard_data_uploadx}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:onboard_data_uploadx_search_stat_config)
        get 'create', {:use_route => :onboard_data_uploadx, :search_stat_config => q}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:onboard_data_uploadx_search_stat_config, :config_desp => nil)
        get 'create', {:use_route => :onboard_data_uploadx, :search_stat_config => q}
        response.should render_template('new')
      end
      
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :last_updated_by_id => @u.id)
        get 'edit', {:use_route => :onboard_data_uploadx, :id => q.id}
        response.should be_success
      end
      
      it "should redirect to previous page for an open process" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :wf_state => 'testing')  
        get 'edit', {:use_route => :onboard_data_uploadx, :id => q.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config)
        get 'update', {:use_route => :onboard_data_uploadx, :id => q.id, :search_stat_config => {:config_desp => 'for biz trip on 4/20'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config)
        get 'update', {:use_route => :onboard_data_uploadx, :id => q.id, :search_stat_config => {:config_desp => nil}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :last_updated_by_id => @u.id, :engine_id => @sw_mod.id)
        get 'show', {:use_route => :onboard_data_uploadx, :id => q.id }
        response.should be_success
      end
    end
    
    describe "GET 'list open process" do
      it "return open process only" do
        user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::SearchStatConfig.scoped.order('created_at DESC')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'search_stat_config_wf_final_state_string', :argument_value => 'decommissioned')
        q = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :created_at => 50.days.ago, :wf_state => 'initial_state')  #created too long ago to show
        q1 = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :wf_state => 'reviewing', :config_desp => 'new')
        q2 = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :wf_state => 'initial_state', :config_desp => 'new+')
        q3 = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :wf_state => 'decommissioned', :config_desp => 'new++')  #wf_state can't be what was defined.
        get 'list_open_process', {:use_route => :onboard_data_uploadx}
        assigns(:search_stat_configs).should =~ [q1, q2]
      end
    end
  end
end
