# This migration comes from onboard_datax (originally 20140520213100)
class CreateOnboardDataxOnboardSearchStatConfigs < ActiveRecord::Migration
  def change
    create_table :onboard_datax_onboard_search_stat_configs do |t|
      t.integer :project_id
      t.integer :last_updated_by_id
      t.integer :search_stat_config_id
      t.text :custom_stat_summary_function
      t.text :custom_search_summary_function
      t.string :custom_stat_header
      t.integer :engine_id
      t.timestamps
      t.integer :release_id
    end
    
    add_index :onboard_datax_onboard_search_stat_configs, :project_id
    add_index :onboard_datax_onboard_search_stat_configs, :search_stat_config_id, :name => :onboard_datax_onboard_search_stat_configs_base_id
    add_index :onboard_datax_onboard_search_stat_configs, :engine_id
    add_index :onboard_datax_onboard_search_stat_configs, :release_id
  end
end
