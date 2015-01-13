require_dependency "onboard_data_uploadx/application_controller"

module OnboardDataUploadx
  class EngineConfigsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Engine Configs')
      @engine_configs =  params[:onboard_data_uploadx_engine_configs][:model_ar_r]
      @engine_configs = @engine_configs.where(:engine_id => eval(OnboardDataUploadx.engine_ids_belong_to_a_project)) if @project_id
      @engine_configs = @engine_configs.where('onboard_data_uploadx_engine_configs.engine_id = ?', @engine.id) if @engine
      @engine_configs = @engine_configs.where('TRIM(onboard_data_uploadx_engine_configs.argument_name) = ?', @argument_name) if @argument_name.present?
      @engine_configs = @engine_configs.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('engine_config_index_view', 'onboard_data_uploadx')
    end

    def new
      @title = t('New Engine Config')
      @engine_config = OnboardDataUploadx::EngineConfig.new
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @erb_code = find_config_const('engine_config_new_view', 'onboard_data_uploadx')
    end


    def create
      @engine_config = OnboardDataUploadx::EngineConfig.new(params[:engine_config], :as => :role_new)
      @engine_config.last_updated_by_id = session[:user_id]
      @engine_config.submitted_by_id = session[:user_id]
      if @engine_config.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
        @erb_code = find_config_const('engine_config_new_view', 'onboard_data_uploadx')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Engine Config')
      @engine_config = OnboardDataUploadx::EngineConfig.find_by_id(params[:id])
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @erb_code = find_config_const('engine_config_edit_view', 'onboard_data_uploadx')
      if @engine_config.wf_state.present? && @engine_config.current_state != :initial_state
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end

    def update
      @engine_config = OnboardDataUploadx::EngineConfig.find_by_id(params[:id])
      @engine_config.last_updated_by_id = session[:user_id]
      if @engine_config.update_attributes(params[:engine_config], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
        @erb_code = find_config_const('engine_config_edit_view', 'onboard_data_uploadx')
        render 'edit'
      end
    end

    def show
      @title = t('Engine Config Info')
      @engine_config = OnboardDataUploadx::EngineConfig.find_by_id(params[:id])
      @erb_code = find_config_const('engine_config_show_view', 'onboard_data_uploadx')
    end
    
    def destroy  
      OnboardDataUploadx::EngineConfig.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    def copy
      @title = t('Copy Engine Config')
      @engine_config = OnboardDataUploadx::EngineConfig.new
      @copy_from = OnboardDataUploadx::EngineConfig.find_by_id(params[:id])
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @erb_code = find_config_const('engine_config_copy_view', 'onboard_data_uploadx')
    end
    
    def list_open_process  
      index()
      @engine_configs = return_open_process(@engine_configs, find_config_const('engine_config_wf_final_state_string', 'onboard_data_uploadx'))  # ModelName_wf_final_state_string
    end
    
    def engine_for_mass_onboard
      @title = t('Select Engines for Onboard')
      @engines = eval(OnboardDataUploadx.engine_ids_belong_to_a_project) if @project_id #engine_id
      @engines = OnboardDataUploadx.engine_class.where(active: true).where(:id => @engines).order('id')
      @engine_boarded, @engine_num_boarded = engine_boarded(OnboardDatax::OnboardEngineConfig.where(project_id: @project_id)) if @project_id
      @erb_code = find_config_const('engine_config_engine_for_mass_onboard_view', 'onboard_data_uploadx')
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Select engine(s) for onboard") if @engines.blank?
    end
    
    def mass_onboard
      #index()
      @title = t('Select Configs for Onboard')
      @project_id = params[:save].keys[0]
      @project = OnboardDataUploadx.project_class.find_by_id(@project_id)
      @engine_ids_array = params[:id_array]
      @erb_code = find_config_const('engine_config_mass_onboard_view', 'onboard_data_uploadx')
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Select config for onboard") if @engine_ids_array.blank?
    end
    
    def mass_onboard_result
      project_id = params[:save].keys[0]
      params['ids'].each do |id|  #ids passed in as 'engine_config_id'
        base = OnboardDataUploadx::EngineConfig.find_by_id(id)
        engine = OnboardDataUploadx.engine_class.find_by_id(base.engine_id)  
       
        onboard_item = OnboardDataUploadx.onboard_engine_config_class.new
        onboard_item.engine_config_id = id
        onboard_item.engine_id = engine.id
        onboard_item.project_id = project_id
        onboard_item.last_updated_by_id = session[:user_id]
        begin
          onboard_item.save
        rescue => e
          flash[:notice] = 'Base#=' + id.to_s  + ',' + e.message
        end
      end unless params['ids'].blank?
      redirect_to  SUBURI + "/view_handler?index=1&url=#{SUBURI + CGI::escape(eval(OnboardDataUploadx.onboard_engine_config_index_path))}"
    end
    
    protected
    def load_record
      @project_id = params[:project_id].to_i if params[:project_id].present?
      @project = OnboardDataUploadx.project_class.find_by_id(@project_id)
      @engine = OnboardDataUploadx.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDataUploadx.engine_class.find_by_id(OnboardDataUploadx::EngineConfig.find_by_id(params[:id]).engine_id) if params[:id].present?
      @argument_name = params[:argument_name].strip if params[:argument_name].present?
    end
  end
end
