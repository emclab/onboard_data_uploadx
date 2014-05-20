# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :onboard_data_uploadx_engine_init, :class => 'OnboardDataUploadx::EngineInit' do
    engine_id 1
    init_desp "MyText"
    init_code "MyText"
    file_name "MyString"
    #last_updated_by_id 1
    #reviewed false
    #reviewed_by_id 1
    #reviewed_date "2014-05-16"
    #tested false
    #tested_by_id 1
    #tested_date "2014-05-16"
    #commissioned false
    #commissioned_by_id 1
    #commissioned_date "2014-05-16"
    #decommissioned false
    #decommissioned_date "2014-05-16"
    #decommissioned_by_id 1
    wf_state "MyString"
    #submitted_by_id 1
  end
end
