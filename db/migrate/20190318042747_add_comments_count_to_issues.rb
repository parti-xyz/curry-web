class AddCommentsCountToIssues < ActiveRecord::Migration[5.0]
  def change
    add_column :issues, :comments_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        transaction do
          Issue.all.each do |issue|
            Issue.reset_counters(issue.id, :comments)
          end
        end
      end
    end
  end
end
