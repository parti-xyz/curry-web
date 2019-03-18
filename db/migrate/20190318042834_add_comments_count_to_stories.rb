class AddCommentsCountToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :comments_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        transaction do
          Story.all.each do |story|
            Story.reset_counters(story.id, :comments)
          end
        end
      end
    end
  end
end
