require 'spec_helper'

module OnboardDataUploadx
  describe EngineInit do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_data_uploadx_engine_init)
      c.should be_valid
    end
    
    it "should reject nil init desp" do
      c = FactoryGirl.build(:onboard_data_uploadx_engine_init, :init_desp => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 engine id" do
      c = FactoryGirl.build(:onboard_data_uploadx_engine_init, :engine_id => 0)
      c.should_not be_valid
    end
    
    it "should reject dup init desp for the same engine name " do
      c = FactoryGirl.create(:onboard_data_uploadx_engine_init, :init_desp => 'a new one')
      c1 = FactoryGirl.build(:onboard_data_uploadx_engine_init, :init_desp => 'A New One')
      c1.should_not be_valid
    end
    
    it "should reject nil init code" do
      c = FactoryGirl.build(:onboard_data_uploadx_engine_init, :init_code => nil)
      c.should_not be_valid
    end
  end
end
