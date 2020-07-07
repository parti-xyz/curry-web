class AddMailedAtToStories < ActiveRecord::Migration[5.0]
  def change
    add_column :stories, :mailed_at, :datetime
  end
end
