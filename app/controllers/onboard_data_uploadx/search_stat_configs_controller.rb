require_dependency "onboard_data_uploadx/application_controller"

module OnboardDataUploadx
  class SearchStatConfigsController < ApplicationController
    before_filter :require_employee
    before_filter :load_record
    
    def index
      @title = t('Search/Stat Configs')
      @search_stat_configs =  params[:onboard_data_uploadx_search_stat_configs][:model_ar_r]
      @search_stat_configs = @search_stat_configs.where(:engine_id => eval(OnboardDataUploadx.engine_ids_belong_to_a_project)) if @project_id
      @search_stat_configs = @search_stat_configs.where('onboard_data_uploadx_search_stat_configs.engine_id = ?', @engine.id) if @engine
      @search_stat_configs = @search_stat_configs.where('TRIM(onboard_data_uploadx_search_stat_configs.resource_name) = ?', @resource_name) if @resource_name
      @search_stat_configs = @search_stat_configs.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('search_stat_config_index_view', 'onboard_data_uploadx')
    end

    def new
      @title = t('New Search/Stat Config')
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @search_stat_config = OnboardDataUploadx::SearchStatConfig.new
      @erb_code = find_config_const('search_stat_config_new_view', 'onboard_data_uploadx')
    end

    def create
      @search_stat_config = OnboardDataUploadx::SearchStatConfig.new(params[:search_stat_config], :as => :role_new)
      @search_stat_config.last_updated_by_id = session[:user_id]
      @search_stat_config.submitted_by_id = session[:user_id]
      if @search_stat_config.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash[:notice] = t('Data Error. Not Saved!')
        @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
        @erb_code = find_config_const('search_stat_config_new_view', 'onboard_data_uploadx')
        render 'new'
      end
    end

    def edit
      @title = t('Edit Search/Stat Config')
      @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
      @search_stat_config = OnboardDataUploadx::SearchStatConfig.find_by_id(params[:id])
      @erb_code = find_config_const('search_stat_config_edit_view', 'onboard_data_uploadx')
      if @search_stat_config.wf_state.present? && @search_stat_config.current_state != :initial_state
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end

    def update
      @search_stat_config = OnboardDataUploadx::SearchStatConfig.find_by_id(params[:id])
      @search_stat_config.last_updated_by_id = session[:user_id]
      if @search_stat_config.update_attributes(params[:search_stat_config], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash[:notice] = t('Data Error. Not Updated!')
        @engines = OnboardDataUploadx.engine_class.where(active: true).order('name')
        @erb_code = find_config_const('search_stat_config_edit_view', 'onboard_data_uploadx')
        render 'edit'
      end
    end

    def show
      @title = t('Search/Stat Config Info')
      @search_stat_config = OnboardDataUploadx::SearchStatConfig.find_by_id(params[:id])
      @erb_code = find_config_const('search_stat_config_show_view', 'onboard_data_uploadx')
    end
    
    def destroy  
      OnboardDataUploadx::SearchStatConfig.delete(params[:id].to_i)
      redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Deleted!")
    end
    
    def list_open_process  
      index()
      @search_stat_configs = return_open_process(@search_stat_configs, find_config_const('search_stat_config_wf_final_state_string', 'onboard_data_uploadx'))  # ModelName_wf_final_state_string
    end
    
    protected
    def load_record
      @project_id = params[:project_id].to_i if params[:project_id].present?
      @engine = OnboardDataUploadx.engine_class.find_by_id(params[:engine_id].to_i) if params[:engine_id].present?
      @engine = OnboardDataUploadx.engine_class.find_by_id(OnboardDataUploadx::SearchStatConfig.find_by_id(params[:id]).engine_id) if params[:id].present?
      @resource_name = params[:resource_name].strip if params[:resource_name].present?
    end
  end
end
