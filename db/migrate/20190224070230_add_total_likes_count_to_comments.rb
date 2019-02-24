class AddTotalLikesCountToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :merged_likes_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE comments
               SET merged_likes_count = likes_count + anonymous_likes_count
          SQL
        end
      end
    end
  end
end
