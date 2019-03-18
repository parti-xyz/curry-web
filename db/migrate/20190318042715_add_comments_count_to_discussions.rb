class AddCommentsCountToDiscussions < ActiveRecord::Migration[5.0]
  def change
    add_column :discussions, :comments_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        transaction do
          Discussion.all.each do |discussion|
            Discussion.reset_counters(discussion.id, :comments)
          end
        end
      end
    end
  end
end
