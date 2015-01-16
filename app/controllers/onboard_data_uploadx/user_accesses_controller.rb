require_dependency "onboard_data_uploadx/application_controller"

module OnboardDataUploadx
  class UserAccessesController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('User Accesses')
      @user_accesses =  params[:onboard_data_uploadx_user_accesses][:model_ar_r]
      @user_accesses = @user_accesses.where(:engine_id => eval(OnboardDataUploadx.engine_ids_belong_to_a_project)) if @project_id
      @user_accesses = @user_accesses.where('onboard_data_uploadx_user_accesses.engine_id = ?', @engine.id) if @engine
      @user_accesses = @user_accesses.where('TRIM(onboard_data_uploadx_user_accesses.action) = ?', @access_action) if @access_action.present?
      @user_accesses = @user_accesses.where('TRIM(onboard_data_uploadx_user_accesses.resource) = ?', @resource) if @resource.present?
      @user_accesses = @user_accesses.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('user_access_index_view', 'onboard_data_uploadx')
    end

    def new
      @title = t('New User Access')
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @user_access = OnboardDataUploadx::UserAccess.new
      if params[:user_access].present?
        @module_info_id = params[:user_access][:engine_id].to_i
        @module_actions = (@module_info_id.present? ? OnboardDataUploadx.module_action_class.where(module_info_id: @module_info_id) : [])
        @module_action_id = params[:user_access][:module_action_id].to_i
      end
      @erb_code = find_config_const('user_access_new_view', 'onboard_data_uploadx')
    end


    def create
      @user_access = OnboardDataUploadx::UserAccess.new(params[:user_access], :as => :role_new)
      @user_access.last_updated_by_id = session[:user_id]
      @user_access.submitted_by_id = session[:user_id]
      if @user_access.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
        @erb_code = find_config_const('user_access_new_view', 'onboard_data_uploadx')
        render 'new'
      end
    end

    def edit
      @title = t('Edit User Access')
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @user_access = OnboardDataUploadx::UserAccess.find_by_id(params[:id])
      if params[:user_access].present?
        @module_info_id = params[:user_access][:engine_id].to_i
        @module_actions = (@module_info_id.present? ? OnboardDataUploadx.module_action_class.where(module_info_id: @module_info_id) : [])
        @module_action_id = params[:user_access][:module_action_id].to_i
      end
      @erb_code = find_config_const('user_access_edit_view', 'onboard_data_uploadx')
      if @user_access.wf_state.present? && @user_access.current_state != :initial_state
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end

    def update
        @user_access = OnboardDataUploadx::UserAccess.find_by_id(params[:id])
        @user_access.last_updated_by_id = session[:user_id]
        if @user_access.update_attributes(params[:user_access], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
          @erb_code = find_config_const('user_access_edit_view', 'onboard_data_uploadx')
          render 'edit'
        end
    end

    def show
      @title = t('User Access Info')
      @user_access = OnboardDataUploadx::UserAccess.find_by_id(params[:id])
      @module_action = OnboardDataUploadx.module_action_class.find_by_id(@user_access.module_action_id) if @user_access.module_action_id.present?
      @erb_code = find_config_const('user_access_show_view', 'onboard_data_uploadx')
    end
    
    def destroy  
      OnboardDataUploadx::UserAccess.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    def copy
      @title = t('Copy User Access')
      @user_access = OnboardDataUploadx::UserAccess.new
      @copy_from = OnboardDataUploadx::UserAccess.find_by_id(params[:id])
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      if params[:user_access].present?
        @module_info_id = params[:user_access][:engine_id].to_i
        @module_actions = (@module_info_id.present? ? OnboardDataUploadx.module_action_class.where(module_info_id: @module_info_id) : [])
        @module_action_id = params[:user_access][:module_action_id].to_i
      end
      @erb_code = find_config_const('user_access_copy_view', 'onboard_data_uploadx')
    end
    
    def list_open_process  
      index()
      @user_accesses = return_open_process(@user_accesses, find_config_const('user_access_wf_final_state_string', 'onboard_data_uploadx'))  # ModelName_wf_final_state_string
    end
    
    def engine_for_mass_onboard
      @title = t('Select Engines for Onboard')
      engine_ids = eval(OnboardDataUploadx.engine_ids_belong_to_a_project) #if @project_id #engine_id
      @engines = OnboardDataUploadx.engine_class.where(active: true).where(:id => engine_ids).order('name')
      @roles = OnboardDataUploadx.project_misc_definition_class.where(:project_id => @project_id).where(:definition_category => 'role_definition').order('ranking_index')
      @engine_boarded, @engine_num_boarded = engine_boarded(OnboardDatax::OnboardUserAccess.where(project_id: @project_id)) if @project_id
      @erb_code = find_config_const('user_access_engine_for_mass_onboard_view', 'onboard_data_uploadx')
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Select engine(s) for onboard") if @engines.blank?
    end
    
    def mass_onboard
      @title = t('Onboard User Access')
      @project_id = params[:save].keys[0]
      @project = OnboardDataUploadx.project_class.find_by_id(@project_id)
      #@roles = OnboardDataUploadx.project_misc_definition_class.where(:project_id => @project_id).where(:definition_category => 'role_definition').order('ranking_index')
      #@engine_ids_array = params[:id_array]
      @engine_ids_array, @roles = return_engine_n_role(params[:id_array])
      @erb_code = find_config_const('user_access_mass_onboard_view', 'onboard_data_uploadx')
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Select access for onboard") if @engine_ids_array.blank?
    end
    
    def mass_onboard_result
      #@title = t('Onboard User Access')
      project_id = params[:save].keys[0]
      params['ids'].each do |id|  #ids passed in as a string of 'user_access_id, role_id'
        id = id.split(',')
        base = OnboardDataUploadx::UserAccess.find_by_id(id[0].to_i)
        engine = OnboardDataUploadx.engine_class.find_by_id(base.engine_id)

        onboard_item = OnboardDataUploadx.onboard_user_access_class.new
        onboard_item.user_access_id = id[0].to_i
        onboard_item.role_definition_id = id[1].to_i
        onboard_item.engine_id = engine.id
        onboard_item.project_id = project_id
        onboard_item.last_updated_by_id = session[:user_id]
        begin
          onboard_item.save
        rescue => e
          flash[:notice] = 'Base#=' + id[0]  + ',' + e.message
        end
      end unless params['ids'].blank?
      redirect_to  SUBURI + "/view_handler?index=1&url=#{SUBURI + CGI::escape(eval(OnboardDataUploadx.onboard_user_access_index_path))}"
    end
    
    protected
    def load_record
      @project_id = params[:project_id].to_i if params[:project_id].present?
      @project = OnboardDataUploadx.project_class.find_by_id(@project_id)
      @engine = OnboardDataUploadx.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDataUploadx.engine_class.find_by_id(OnboardDataUploadx::UserAccess.find_by_id(params[:id]).engine_id) if params[:id].present?
      @access_action = params[:access_action].strip if params[:access_action].present?
      @resource = params[:resource].strip if params[:resource].present?
    end
    
    def return_engine_n_role(ids_array)
      engine_ids = []
      role_ids = []
      ids_array.each do |id|  #ids passed in as a string of 'user_access_id, role_id'
        id = id.split(',')
        engine_ids << id[0].to_i unless engine_ids.include?(id[0].to_i)
        role_ids << id[1].to_i unless role_ids.include?(id[1].to_i)
      end      
      return engine_ids, OnboardDataUploadx.project_misc_definition_class.where(:id => role_ids).order('ranking_index')
    end
    
  end
end
