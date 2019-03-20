class AddCommentsCountToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :comments_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        transaction do
          Comment.all.each do |survey|
            Comment.reset_counters(survey.id, :comments)
          end
        end
      end
    end
  end
end
