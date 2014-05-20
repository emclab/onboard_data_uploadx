require 'spec_helper'

module OnboardDataUploadx
  describe EngineConfig do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_data_uploadx_engine_config)
      c.should be_valid
    end
    
    it "should reject nil argument desp" do
      c = FactoryGirl.build(:onboard_data_uploadx_engine_config, :argument_desp => nil)
      c.should_not be_valid
    end
    
    it "should reject dup argument desp for argument name and engine name when there is engine name" do
      c = FactoryGirl.create(:onboard_data_uploadx_engine_config, :argument_desp => 'a new one')
      c1 = FactoryGirl.build(:onboard_data_uploadx_engine_config, :argument_desp => 'A New One')
      c1.should_not be_valid
    end
    
    it "should reject dup argument desp for argument name and engine name when there is nil engine name" do
      c = FactoryGirl.create(:onboard_data_uploadx_engine_config, :argument_desp => 'a new one', :engine_name => nil)
      c1 = FactoryGirl.build(:onboard_data_uploadx_engine_config, :argument_desp => 'A New One', :engine_name => nil)
      c1.should_not be_valid
    end
    
    it "should reject nil argument name" do
      c = FactoryGirl.build(:onboard_data_uploadx_engine_config, :argument_name => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 engine id" do
      c = FactoryGirl.build(:onboard_data_uploadx_engine_config, :engine_id => 0)
      c.should_not be_valid
    end
    
  end
end
