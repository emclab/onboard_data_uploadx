require_dependency "onboard_data_uploadx/application_controller"

module OnboardDataUploadx
  class EngineInitsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Engine Inits')
      @engine_inits =  params[:onboard_data_uploadx_engine_inits][:model_ar_r]
      @engine_inits = @engine_inits.where(:engine_id => eval(OnboardDataUploadx.engine_ids_belong_to_a_project)) if @project_id
      @engine_inits = @engine_inits.where('onboard_data_uploadx_engine_inits.engine_id = ?', @engine.id) if @engine
      @engine_inits = @engine_inits.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('engine_init_index_view', 'onboard_data_uploadx')
    end

    def new
      @title = t('New Engine Init')
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @engine_init = OnboardDataUploadx::EngineInit.new
      @erb_code = find_config_const('engine_init_new_view', 'onboard_data_uploadx')
    end


    def create
      @engine_init = OnboardDataUploadx::EngineInit.new(params[:engine_init], :as => :role_new)
      @engine_init.last_updated_by_id = session[:user_id]
      @engine_init.submitted_by_id = session[:user_id]
      if @engine_init.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
        @erb_code = find_config_const('engine_init_new_view', 'onboard_data_uploadx')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Engine Init')
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @engine_init = OnboardDataUploadx::EngineInit.find_by_id(params[:id])
      @erb_code = find_config_const('engine_init_edit_view', 'onboard_data_uploadx')
      if @engine_init.wf_state.present? && @engine_init.current_state != :initial_state
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end

    def update
        @engine_init = OnboardDataUploadx::EngineInit.find_by_id(params[:id])
        @engine_init.last_updated_by_id = session[:user_id]
        if @engine_init.update_attributes(params[:engine_init], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
        else
          flash[:notice] = t('Data Error. Not Updated!')
          @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
          @erb_code = find_config_const('engine_init_edit_view', 'onboard_data_uploadx')
          render 'edit'
        end
    end

    def show
      @title = t('Engine Init Info')
      @engine_init = OnboardDataUploadx::EngineInit.find_by_id(params[:id])
      @erb_code = find_config_const('engine_init_show_view', 'onboard_data_uploadx')
    end
    
    def destroy  
      OnboardDataUploadx::EngineInit.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    def copy
      @title = t('Copy Engine Init')
      @engine_init = OnboardDataUploadx::EngineInit.new
      @copy_from = OnboardDataUploadx::EngineInit.find_by_id(params[:id])
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @erb_code = find_config_const('engine_init_copy_view', 'onboard_data_uploadx')
    end
    
    def list_open_process  
      index()
      @engine_inits = return_open_process(@engine_inits, find_config_const('engine_init_wf_final_state_string', 'onboard_data_uploadx'))  # ModelName_wf_final_state_string
    end
    
    protected
    def load_record
      @project_id = params[:project_id].to_i if params[:project_id].present?
      @project = OnboardDataUploadx.project_class.find_by_id(@project_id) if @project_id
      @engine = OnboardDataUploadx.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDataUploadx.engine_class.find_by_id(OnboardDataUploadx::EngineInit.find_by_id(params[:id]).engine_id) if params[:id].present?      
    end
  end
end
