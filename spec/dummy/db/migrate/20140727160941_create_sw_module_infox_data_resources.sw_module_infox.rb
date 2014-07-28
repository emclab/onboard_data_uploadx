# This migration comes from sw_module_infox (originally 20140721024746)
class CreateSwModuleInfoxDataResources < ActiveRecord::Migration
  def change
    create_table :sw_module_infox_data_resources do |t|
      t.integer :module_info_id
      t.string :name
      t.string :name_non_tech
      t.string :brief_note

      t.timestamps
    end
    
    add_index :sw_module_infox_data_resources, :module_info_id
  end
end
