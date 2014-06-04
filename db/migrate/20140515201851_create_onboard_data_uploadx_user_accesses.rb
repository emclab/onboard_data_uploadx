class CreateOnboardDataUploadxUserAccesses < ActiveRecord::Migration
  def change
    create_table :onboard_data_uploadx_user_accesses do |t|
      t.integer :engine_id
      t.string :action
      t.string :resource
      t.text :brief_note
      t.integer :last_updated_by_id
      t.text :sql_code
      t.text :masked_attrs
      t.integer :rank
      t.boolean :commissioned, :default => false
      t.date :commissioned_date
      t.string :wf_state
      t.boolean :decommissioned, :default => false
      t.date :decommissioned_date
      t.text :access_desp
      t.integer :submitted_by_id
      t.integer :commissioned_by_id
      t.integer :decommissioned_by_id
      t.boolean :reviewed, :default => false
      t.integer :reviewed_by_id
      t.date :reviewed_date
      t.boolean :tested, :default => false
      t.integer :tested_by_id
      t.date :tested_date

      t.timestamps
    end
    
    add_index :onboard_data_uploadx_user_accesses, :action
    add_index :onboard_data_uploadx_user_accesses, :engine_id
    add_index :onboard_data_uploadx_user_accesses, :resource
    add_index :onboard_data_uploadx_user_accesses, [:action, :resource]
    add_index :onboard_data_uploadx_user_accesses, :wf_state
    add_index :onboard_data_uploadx_user_accesses, :commissioned
    add_index :onboard_data_uploadx_user_accesses, :decommissioned
    add_index :onboard_data_uploadx_user_accesses, :reviewed
    add_index :onboard_data_uploadx_user_accesses, :submitted_by_id
    add_index :onboard_data_uploadx_user_accesses, :commissioned_by_id
    add_index :onboard_data_uploadx_user_accesses, :reviewed_by_id
    add_index :onboard_data_uploadx_user_accesses, :decommissioned_by_id, :name => :onboard_data_uploadx_user_accesses_decomed_by
    add_index :onboard_data_uploadx_user_accesses, :tested_by_id
  end
end
