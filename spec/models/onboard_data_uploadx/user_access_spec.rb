require 'spec_helper'

module OnboardDataUploadx
  describe UserAccess do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access)
      c.should be_valid
    end
    
    it "should take nil access desp when sql code is nil" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :access_desp => nil, :sql_code => nil)
      c.should be_valid
    end
    
    it "should reject nil access desp when sql code is present" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :access_desp => nil, :sql_code => "nil")
      c.should_not be_valid
    end
    
    it "should reject dup action when resource, sql code and masked attrs are the same" do
      c = FactoryGirl.create(:onboard_data_uploadx_user_access, :action => 'a new one')
      c1 = FactoryGirl.build(:onboard_data_uploadx_user_access, :action => 'A New One')
      c1.should_not be_valid
    end
    
    it "should reject dup action when resource, sql code and masked attrs are the same" do
      c = FactoryGirl.create(:onboard_data_uploadx_user_access, :action => 'a new one', :sql_code => nil, :masked_attrs => nil)
      c1 = FactoryGirl.build(:onboard_data_uploadx_user_access, :action => 'A New One', :sql_code => nil, :masked_attrs => nil)
      c1.should_not be_valid
    end
    
    it "should reject nil action" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :action => nil)
      c.should_not be_valid
    end
    
    it "should reject nil resource" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :resource => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 engine id" do
      c = FactoryGirl.build(:onboard_data_uploadx_user_access, :engine_id => 0)
      c.should_not be_valid
    end
  end
end
