require 'spec_helper'

describe "LinkTests" do
  describe "GET /onboard_data_uploadx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      wf = "def submit
          wf_common_action('initial_state', 'reviewing', 'submit')
        end   
        def review_pass
          wf_common_action('reviewing', 'testing', 'review_pass')
        end 
        def review_reject
          wf_common_action('reviewing', 'initial_state', 'review_reject')
        end
        def test_pass
          wf_common_action('testing', 'commissioning', 'test_pass')
        end 
        def test_reject
          wf_common_action('testing', 'initial_state', 'test_reject')
        end      
        def commission
          wf_common_action('commissioning', 'commissioned', 'commissioned')
        end
        def decommission
          wf_common_action('commissioned', 'decommissioned', 'decommission')
        end
        def rewind
          wf_common_action('commissioning', 'initial_state', 'rewind')
        end
        "
      FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'engine_config_wf_action_def', :argument_value => wf)
      str = 'decommissioned'
      FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'engine_init_wf_final_state_string', :argument_value => str)
      FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'search_stat_engine_wf_final_state_string', :argument_value => str)
      FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'user_access_wf_final_state_string', :argument_value => str)
      FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'engine_config_pay_inline', 
                         :argument_value => "<%= f.input :paid_date, :label => t('Paid Date') , :as => :string %>
                                             <%= f.input :paid_by_id, :as => :hidden, :input_html => {:value => session[:user_id]}%>
                                             <%= f.input :paid, :as => :hidden, :input_html => {:value => true} %>")
      FactoryGirl.create(:engine_config, :engine_name => 'onboard_data_uploadx', :engine_version => nil, :argument_name => 'validate_engine_config_pay', 
                         :argument_value => " errors.add(:paid_date, I18n.t('Not be blank')) if paid_date.blank?
                                               ")   
                         
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => nil)
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
      
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      exp_category = FactoryGirl.create(:commonx_misc_definition, :name => 'exp_category', :for_which => 'exp_category')
      
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::EngineConfig.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      #  
      user_access = FactoryGirl.create(:user_access, :action => 'event_action', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::EngineConfig.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'submit', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'pay', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'store_manager_approve', :resource =>'onboard_data_uploadx_engine_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      #user access
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_data_uploadx_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::UserAccess.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_data_uploadx_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_data_uploadx_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_data_uploadx_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      #  
      user_access = FactoryGirl.create(:user_access, :action => 'event_action', :resource =>'onboard_data_uploadx_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'onboard_data_uploadx_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::UserAccess.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'submit', :resource =>'onboard_data_uploadx_user_accesses', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      #engine init
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_data_uploadx_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::EngineInit.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_data_uploadx_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_data_uploadx_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_data_uploadx_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      #  
      user_access = FactoryGirl.create(:user_access, :action => 'event_action', :resource =>'onboard_data_uploadx_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'onboard_data_uploadx_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::EngineInit.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'submit', :resource =>'onboard_data_uploadx_engine_inits', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      #search stat config
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::SearchStatConfig.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.last_updated_by_id == session[:user_id]")
      #  
      user_access = FactoryGirl.create(:user_access, :action => 'event_action', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "OnboardDataUploadx::SearchStatConfig.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'submit', :resource =>'onboard_data_uploadx_search_stat_configs', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      
      @engine = FactoryGirl.create(:sw_module_infox_module_info, :name => 'myengine', :active => true)
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works for engine config" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit engine_configs_path
      save_and_open_page
      task = FactoryGirl.create(:onboard_data_uploadx_engine_config, :last_updated_by_id => @u.id, :submitted_by_id => @u.id, :engine_id => @engine.id)
      visit engine_configs_path
      save_and_open_page
      page.should have_content('Engine Configs')
      page.should have_content('Initial State')  #for workflow
      page.should have_content('Submit Config Data')
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Engine Config')
      #save_and_open_page
      fill_in 'engine_config_argument_name', :with => '230'
      click_button "Save"
      #bad data
      visit engine_configs_path
      click_link 'Edit'
      fill_in 'engine_config_argument_desp', :with => nil
      click_button "Save"
      #save_and_open_page
      
      #show
      visit engine_configs_path
      #save_and_open_page
      click_link task.id.to_s
      save_and_open_page
      page.should have_content('Engine Config Info')
      
      #new
      visit new_engine_config_path()
      save_and_open_page
      page.should have_content('New Engine Config')
      select('myengine', :from => 'engine_config_engine_id')
      fill_in 'engine_config_argument_desp', :with =>  '230'
      fill_in 'engine_config_brief_note', :with => 'for biz trip'
      click_button 'Save'
      #save_and_open_page
      #bad data
      visit new_engine_config_path()
      #fill_in 'engine_config_argument_name', :with => ''
      fill_in 'engine_config_argument_desp', :with =>  '230'
      fill_in 'engine_config_brief_note', :with => 'for biz trip'
      click_button 'Save'
      #save_and_open_page
    end
    
    it "works for user access" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      task = FactoryGirl.create(:onboard_data_uploadx_user_access, :submitted_by_id => @u.id, :engine_id => @engine.id)
      visit user_accesses_path
      save_and_open_page
      page.should have_content('User Accesses')
      page.should have_content('Initial State')  #for workflow
      page.should have_content('Submit User Access')
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit User Access')
      #save_and_open_page
      fill_in 'user_access_resource', :with => '230'
      click_button "Save"
      #bad data
      visit user_accesses_path
      click_link 'Edit'
      fill_in 'user_access_resource', :with => nil
      click_button "Save"
      #save_and_open_page
      
      #show
      visit user_accesses_path
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('User Access Info')
      
      #new
      visit new_user_access_path()
      #save_and_open_page
      page.should have_content('New User Access')
      select('myengine', :from => 'user_access_engine_id')
      fill_in 'user_access_action', :with => '2014-04-11'
      fill_in 'user_access_resource', :with =>  '230'
      fill_in 'user_access_access_desp', :with => 'for biz trip'
      click_button 'Save'
      #save_and_open_page
      #bad data
      visit new_user_access_path()
      select('myengine', :from => 'user_access_engine_id')
      fill_in 'user_access_action', :with => ''
      fill_in 'user_access_access_desp', :with =>  '230'
      fill_in 'user_access_resource', :with => 'for biz trip'
      click_button 'Save'
      #save_and_open_page
    end
    
    it "works for engine init" do
      task = FactoryGirl.create(:onboard_data_uploadx_engine_init, :submitted_by_id => @u.id, :engine_id => @engine.id)
      visit engine_inits_path
      save_and_open_page
      page.should have_content('Engine Inits')
      page.should have_content('Initial State')  #for workflow
      page.should have_content('Submit Engine Init')
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Engine Init')
      #save_and_open_page
      fill_in 'engine_init_init_desp', :with => '230'
      click_button "Save"
      #bad data
      visit engine_inits_path
      click_link 'Edit'
      fill_in 'engine_init_init_desp', :with => nil
      click_button "Save"
      #save_and_open_page
      
      #show
      visit engine_inits_path
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('Engine Init Info')
      
      #new
      visit new_engine_init_path()
      #save_and_open_page
      page.should have_content('New Engine Init')
      select('myengine', :from => 'engine_init_engine_id')
      fill_in 'engine_init_init_desp', :with =>  '230'
      fill_in 'engine_init_init_code', :with => 'for biz trip'
      click_button 'Save'
      #save_and_open_page
      #bad data
      visit new_engine_init_path()
      select('myengine', :from => 'engine_init_engine_id')
      fill_in 'engine_init_init_desp', :with =>  ''
      fill_in 'engine_init_init_code', :with => 'for biz trip'
      click_button 'Save'
      save_and_open_page
    end
    
    it "works for search stat config" do
      task = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :submitted_by_id => @u.id, :engine_id => @engine.id)
      visit search_stat_configs_path
      save_and_open_page
      page.should have_content('Search/Stat Configs')
      page.should have_content('Initial State')  #for workflow
      page.should have_content('Submit Search/Stat Config')
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Edit Search/Stat Config')
      #save_and_open_page
      fill_in 'search_stat_config_config_desp', :with => '230'
      click_button "Save"
      #bad data
      visit search_stat_configs_path
      click_link 'Edit'
      fill_in 'search_stat_config_config_desp', :with => nil
      click_button "Save"
      #save_and_open_page
      
      #show
      visit search_stat_configs_path
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('Search/Stat Config Info')
      
      #new
      visit new_search_stat_config_path()
      #save_and_open_page
      page.should have_content('New Search/Stat Config')
      select('myengine', :from => 'search_stat_config_engine_id')
      fill_in 'search_stat_config_config_desp', :with =>  '230'
      fill_in 'search_stat_config_resource_name', :with => 'for biz trip'
      click_button 'Save'
      #save_and_open_page
      #bad data
      visit new_search_stat_config_path()
      select('myengine', :from => 'search_stat_config_engine_id')
      fill_in 'search_stat_config_config_desp', :with =>  ''
      fill_in 'search_stat_config_resource_name', :with => 'for biz trip'
      click_button 'Save'
      save_and_open_page
    end
    
  end
end
