# This migration comes from sw_module_infox (originally 20140721021733)
class CreateSwModuleInfoxModuleActions < ActiveRecord::Migration
  def change
    create_table :sw_module_infox_module_actions do |t|
      t.integer :module_info_id
      t.string :name
      t.string :name_non_tech
      t.integer :data_resource_id
      t.string :desp
      t.string :desp_non_tech
      t.boolean :present_to_customer
      t.integer :last_updated_by_id

      t.timestamps
    end
    
    add_index :sw_module_infox_module_actions, :module_info_id
    add_index :sw_module_infox_module_actions, :name
    add_index :sw_module_infox_module_actions, :data_resource_id
    add_index :sw_module_infox_module_actions, :present_to_customer
  end
end
