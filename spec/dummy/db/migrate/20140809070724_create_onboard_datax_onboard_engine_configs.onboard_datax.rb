# This migration comes from onboard_datax (originally 20140520212833)
class CreateOnboardDataxOnboardEngineConfigs < ActiveRecord::Migration
  def change
    create_table :onboard_datax_onboard_engine_configs do |t|
      t.integer :project_id
      t.integer :last_updated_by_id
      t.integer :engine_config_id
      t.text :custom_argument_value
      t.integer :engine_id
      
      t.timestamps
    end
    
    add_index :onboard_datax_onboard_engine_configs, :project_id
    add_index :onboard_datax_onboard_engine_configs, :engine_config_id
    add_index :onboard_datax_onboard_engine_configs, :engine_id
  end
end
