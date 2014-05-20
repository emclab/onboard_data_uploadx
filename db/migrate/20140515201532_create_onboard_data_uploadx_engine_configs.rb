class CreateOnboardDataUploadxEngineConfigs < ActiveRecord::Migration
  def change
    create_table :onboard_data_uploadx_engine_configs do |t|
      t.integer :engine_id
      t.string :engine_version
      t.string :argument_name
      t.text :argument_value
      t.integer :last_updated_by_id
      t.text :brief_note
      t.boolean :global
      t.boolean :commissioned, :default => false
      t.date :commissioned_date
      t.string :wf_state
      t.boolean :decommissioned, :default => false
      t.date :decommissioned_date
      t.text :argument_desp
      t.integer :submitted_by_id
      t.integer :commissioned_by_id
      t.integer :decommissioned_by_id
      t.boolean :reviewed, :default => false
      t.integer :reviewed_by_id
      t.date :reviewed_date
      t.boolean :tested, :default => false
      t.date :tested_date
      t.integer :tested_by_id

      t.timestamps
    end
    
    add_index :onboard_data_uploadx_engine_configs, :engine_id
    add_index :onboard_data_uploadx_engine_configs, :argument_name
    add_index :onboard_data_uploadx_engine_configs, :wf_state
    add_index :onboard_data_uploadx_engine_configs, :commissioned
    add_index :onboard_data_uploadx_engine_configs, :decommissioned
    add_index :onboard_data_uploadx_engine_configs, :reviewed
    add_index :onboard_data_uploadx_engine_configs, :submitted_by_id
    add_index :onboard_data_uploadx_engine_configs, :reviewed_by_id
    add_index :onboard_data_uploadx_engine_configs, :commissioned_by_id
    add_index :onboard_data_uploadx_engine_configs, :decommissioned_by_id, :name => :onboard_data_uploadx_engine_configs_dec_id
    add_index :onboard_data_uploadx_engine_configs, :tested
  end
end
