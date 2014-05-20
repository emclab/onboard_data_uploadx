# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :onboard_data_uploadx_user_access, :class => 'OnboardDataUploadx::UserAccess' do
    engine_id 1
    action "MyString"
    resource "MyString"
    brief_note "MyText"
    #last_updated_by_id 1
    sql_code "MyText"
    masked_attrs "MyText"
    rank 1
    #commissioned false
    #commissioned_date "2014-05-15"
    #wf_state "MyString"
    #decommissioned false
    #decommissioned_date "2014-05-15"
    access_desp "MyText"
    #submitted_by_id 1
    #commissioned_by_id 1
    #decommissioned_by_id 1
    #reviewed false
    #reviewed_by_id 1
  end
end
