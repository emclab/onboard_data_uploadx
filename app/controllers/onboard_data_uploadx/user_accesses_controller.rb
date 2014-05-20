require_dependency "onboard_data_uploadx/application_controller"

module OnboardDataUploadx
  class UserAccessesController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('User Accesses')
      @user_accesses =  params[:onboard_data_uploadx_user_accesses][:model_ar_r]
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
      @erb_code = find_config_const('@user_access_edit_view', 'onboard_data_uploadx')
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
      @erb_code = find_config_const('user_access_show_view', 'onboard_data_uploadx')
    end
    
    def list_open_process  
      index()
      @user_accesses = return_open_process(@user_accesses, find_config_const('user_access_wf_final_state_string', 'onboard_data_uploadx'))  # ModelName_wf_final_state_string
    end
    
    protected
    def load_record
      @engine = OnboardDataUploadx.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDataUploadx.engine_class.find_by_id(OnboardDataUploadx::UserAccess.find_by_id(params[:id]).engine_id) if params[:id].present?
      @access_action = params[:access_action].strip if params[:access_action].present?
      @resource = params[:resource].strip if params[:resource].present?
    end
  end
end
