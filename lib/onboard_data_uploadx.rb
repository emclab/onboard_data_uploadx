require "onboard_data_uploadx/engine"

module OnboardDataUploadx
 mattr_accessor :engine_class, :engine_ids_belong_to_a_project
 
 def self.engine_class
   @@engine_class.constantize
 end
end
