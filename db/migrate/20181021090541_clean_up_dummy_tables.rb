class CleanUpDummyTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :candidates
    drop_table :comments_target_speakers
    drop_table :events
    drop_table :events_speakers
    drop_table :petitions
    drop_table :petitions_speakers
    drop_table :project_admins
    drop_table :sns_events
    drop_table :speakers
  end
end
