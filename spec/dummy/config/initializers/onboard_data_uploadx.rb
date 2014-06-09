OnboardDataUploadx.engine_class = 'SwModuleInfox::ModuleInfo'
OnboardDataUploadx.engine_ids_belong_to_a_project = "ResourceAllocx::Allocation.where(:resource_id => @project_id, :resource_string => 'ext_construction_projectx/projects').select('detailed_resource_id')"
OnboardDataUploadx.onboard_engine_config_class = 'OnboardDatax::OnboardEngineConfig'
OnboardDataUploadx.onboard_engine_init_class = 'OnboardDatax::OnboardEngineInit'
OnboardDataUploadx.onboard_search_stat_config_class = 'OnboardDatax::OnboardSearchStatConfig'
OnboardDataUploadx.onboard_user_access_class = 'OnboardDatax::OnboardUserAccess'
OnboardDataUploadx.project_misc_definition_class = 'ProjectMiscDefinitionx::MiscDefinition'
OnboardDataUploadx.onboard_user_access_index_path = 'onboard_datax.onboard_user_accesses_path(project_id: project_id)' 
OnboardDataUploadx.onboard_engine_config_index_path = 'onboard_datax.onboard_engine_configs_path(project_id: project_id)'
