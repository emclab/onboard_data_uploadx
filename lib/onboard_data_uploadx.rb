require "onboard_data_uploadx/engine"

module OnboardDataUploadx
 mattr_accessor :engine_class, :engine_ids_belong_to_a_project, :project_class, :onboard_engine_config_class, :onboard_engine_init_class, :onboard_search_stat_config_class, 
                :onboard_user_access_class, :project_misc_definition_class, :onboard_user_access_index_path, :onboard_engine_config_index_path
 
 def self.engine_class
   @@engine_class.constantize
 end
 
 def self.project_class
   @@project_class.constantize
 end
 
 def self.onboard_engine_config_class
   @@onboard_engine_config_class.constantize
 end
 
 def self.onboard_engine_init_class
   @@onboard_engine_init_class.constantize
 end
 
 def self.onboard_search_stat_config_class
   @@onboard_search_stat_config_class.constantize
 end
 
 def self.onboard_user_access_class
   @@onboard_user_access_class.constantize
 end
 
 def self.project_misc_definition_class
   @@project_misc_definition_class.constantize
 end
 
end
