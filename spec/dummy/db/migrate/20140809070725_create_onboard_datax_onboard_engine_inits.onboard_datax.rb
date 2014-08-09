# This migration comes from onboard_datax (originally 20140520212942)
class CreateOnboardDataxOnboardEngineInits < ActiveRecord::Migration
  def change
    create_table :onboard_datax_onboard_engine_inits do |t|
      t.integer :project_id
      t.integer :last_updated_by_id
      t.integer :engine_init_id
      t.integer :engine_id

      t.timestamps
    end
    
    add_index :onboard_datax_onboard_engine_inits, :project_id
    add_index :onboard_datax_onboard_engine_inits, :engine_init_id
    add_index :onboard_datax_onboard_engine_inits, :engine_id
  end
end
