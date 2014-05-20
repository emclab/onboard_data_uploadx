# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :onboard_data_uploadx_engine_config, :class => 'OnboardDataUploadx::EngineConfig' do
    engine_id 1
    engine_version "MyString"
    argument_name "MyString"
    argument_value "MyText"
    #last_updated_by_id 1
    brief_note "MyText"
    global false
    #commissioned false
    #commissioned_date "2014-05-15"
    wf_state "MyString"
    #decommissioned false
    #decommissioned_date "2014-05-15"
    argument_desp "MyText"
    #submitted_by_id 1
    #commissioned_by_id 1
    #decommissioned_by_id 1
    #reviewed false
    #reviewed_by_id 1
  end
end
