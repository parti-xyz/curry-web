class EnlargeBodyOfStories < ActiveRecord::Migration[5.2]
  def change
    change_column :stories, :body, :text, limit: 16777215
  end
end
