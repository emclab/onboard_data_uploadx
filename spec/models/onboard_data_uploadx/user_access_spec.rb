require 'spec_helper'

module OnboardDataUploadx
  describe UserAccess do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access)
      c.should be_valid
    end
    
    it "should reject nil argument desp" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :access_desp => nil)
      c.should_not be_valid
    end
    
    it "should reject dup argument desp for argument name and engine name" do
      c = FactoryGirl.create(:onboard_data_uploadx_user_access, :access_desp => 'a new one')
      c1 = FactoryGirl.build(:onboard_data_uploadx_user_access, :access_desp => 'A New One')
      c1.should_not be_valid
    end
    
    it "should reject nil argument name" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :action => nil)
      c.should_not be_valid
    end
    
    it "should reject nil argument name" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :resource => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 engine id" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :engine_id => 0)
      c.should_not be_valid
    end
  end
end
