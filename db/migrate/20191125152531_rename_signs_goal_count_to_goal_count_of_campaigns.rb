class RenameSignsGoalCountToGoalCountOfCampaigns < ActiveRecord::Migration[5.0]
  def change
    rename_column :campaigns, :signs_goal_count, :goal_count
  end
end
