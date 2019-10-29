class AddFacebookToAgents < ActiveRecord::Migration[5.0]
  def change
    add_column :agents, :facebook, :string
  end
end
