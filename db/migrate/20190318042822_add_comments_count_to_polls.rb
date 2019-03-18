class AddCommentsCountToPolls < ActiveRecord::Migration[5.0]
  def change
    add_column :polls, :comments_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        transaction do
          Poll.all.each do |poll|
            Poll.reset_counters(poll.id, :comments)
          end
        end
      end
    end
  end
end
