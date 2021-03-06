require 'spec_helper'

module OnboardDataUploadx
  describe SearchStatConfig do
    it "should be OK" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config)
      c.should be_valid
    end
    
    it "should reject nil config desp" do
      c = FactoryGirl.build(:onboard_data_uploadx_search_stat_config, :config_desp => nil)
      c.should_not be_valid
    end
    
    it "should reject dup config desp for config name and engine name" do
      c = FactoryGirl.create(:onboard_data_uploadx_search_stat_config, :config_desp => 'a new one')
      c1 = FactoryGirl.build(:onboard_data_uploadx_search_stat_config, :config_desp => 'A New One')
      c1.should_not be_valid
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
