require 'spec_helper'

module OnboardDataUploadx
  describe SearchStatConfig do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config)
      c.should be_valid
    end
    
    it "should take nil config desp" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config, :config_desp => nil)
      c.should be_valid
    end
    
    it "should reject search where" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config, :search_where => nil)
      c.should_not be_valid
    end
    
    it "should reject labels & fields" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config, :labels_and_fields => nil)
      c.should_not be_valid
    end
    
    it "should reject search list form" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config, :search_list_form => nil)
      c.should_not be_valid
    end
    
    it "should reject nil resourcet name" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config, :resource_name => nil)
      c.should_not be_valid
    end
    
    it "should reject 0 engine id" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config, :engine_id => 0)
      c.should_not be_valid
    end
  end
end
