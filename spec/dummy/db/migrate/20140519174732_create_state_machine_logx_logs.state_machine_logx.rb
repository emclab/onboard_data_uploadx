# This migration comes from state_machine_logx (originally 20131229173952)
class CreateStateMachineLogxLogs < ActiveRecord::Migration
  def change
    create_table :state_machine_logx_logs do |t|
      t.string :resource_string
      t.integer :resource_id
      t.string :event
      t.string :action_by_name
      t.text :comment
      t.string :from
      t.string :to
      t.text :error_message
      t.integer :last_updated_by_id

      t.timestamps
    end
    
    add_index :state_machine_logx_logs, :resource_string
    add_index :state_machine_logx_logs, :resource_id
    add_index :state_machine_logx_logs, [:resource_string, :resource_id], :name => :state_machine_logx_logs_resources
  end
end
