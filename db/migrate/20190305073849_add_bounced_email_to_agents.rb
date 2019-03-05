class AddBouncedEmailToAgents < ActiveRecord::Migration[5.0]
  def change
    add_column :agents, :bounced_email, :boolean, default: false
  end
end
