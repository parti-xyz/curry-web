class AddPhoneToAgents < ActiveRecord::Migration[5.0]
  def change
    add_column :agents, :phone, :string
    add_column :agents, :fax, :string
  end
end
