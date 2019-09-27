class AddNeedStanceOfCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :need_stance, :boolean, default: true
  end
end
