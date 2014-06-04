OnboardDataUploadx.engine_class = 'SwModuleInfox::ModuleInfo'
OnboardDataUploadx.engine_ids_belong_to_a_project = "ResourceAllocx::Allocation.where(:resource_id => @project_id, :resource_string => 'ext_construction_projectx/projects').select('detailed_resource_id')"
