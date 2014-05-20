class CreateOnboardDataUploadxSearchStatConfigs < ActiveRecord::Migration
  def change
    create_table :onboard_data_uploadx_search_stat_configs do |t|
      t.string :resource_name
      t.text :stat_function
      t.text :stat_summary_function
      t.text :labels_and_fields
      t.string :time_frame
      t.string :search_list_form
      t.text :search_where
      t.text :search_results_period_limit
      t.integer :last_updated_by_id
      t.text :brief_note
      t.string :stat_header
      t.text :search_params
      t.text :search_summary_function
      t.text :config_desp
      t.integer :engine_id
      t.boolean :reviewed, :default => false
      t.integer :reviewed_by_id
      t.date :reviewed_date
      t.boolean :tested, :default => false
      t.integer :tested_by_id
      t.date :tested_date
      t.boolean :commissioned, :default => false
      t.integer :commissioned_by_id
      t.date :commissioned_date
      t.boolean :decommissioned, :default => false
      t.date :decommissioned_date
      t.integer :decommissioned_by_id
      t.integer :submitted_by_id
      t.string :wf_state

      t.timestamps
    end
    
    add_index :onboard_data_uploadx_search_stat_configs, :resource_name
    add_index :onboard_data_uploadx_search_stat_configs, :engine_id
    add_index :onboard_data_uploadx_search_stat_configs, :config_desp
    add_index :onboard_data_uploadx_search_stat_configs, :wf_state
  end
end
