require "onboard_data_uploadx/engine"

module OnboardDataUploadx
 mattr_accessor :engine_class
 
 def self.engine_class
   @@engine_class.constantize
 end
end
