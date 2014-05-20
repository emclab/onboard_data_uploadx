# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :onboard_data_uploadx_search_stat_config, :class => 'OnboardDataUploadx::SearchStatConfig' do
    resource_name "MyString"
    stat_function "MyText"
    stat_summary_function "MyText"
    labels_and_fields "MyText"
    time_frame "MyString"
    search_list_form "MyString"
    search_where "MyText"
    search_results_period_limit "MyText"
    #last_updated_by_id 1
    brief_note "MyText"
    stat_header "MyString"
    search_params "MyText"
    search_summary_function "MyText"
    config_desp "MyText"
    engine_id 1
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
    ##decommissioned_date "2014-05-16"
    #decommissioned_by_id 1
    #submitted_by_id 1
  end
end
