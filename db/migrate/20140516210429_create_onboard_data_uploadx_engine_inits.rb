class CreateOnboardDataUploadxEngineInits < ActiveRecord::Migration
  def change
    create_table :onboard_data_uploadx_engine_inits do |t|
      t.integer :engine_id
      t.text :init_desp
      t.text :init_code
      t.string :file_name
      t.integer :last_updated_by_id
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
      t.string :wf_state
      t.integer :submitted_by_id

      t.timestamps
    end
    
    add_index :onboard_data_uploadx_engine_inits, :engine_id
    add_index :onboard_data_uploadx_engine_inits, :file_name
    add_index :onboard_data_uploadx_engine_inits, :init_desp
    add_index :onboard_data_uploadx_engine_inits, :submitted_by_id
    add_index :onboard_data_uploadx_engine_inits, :commissioned
    add_index :onboard_data_uploadx_engine_inits, :decommissioned
    add_index :onboard_data_uploadx_engine_inits, :reviewed
    add_index :onboard_data_uploadx_engine_inits, :tested
  end
end
