class AddIsHtmlBodyOfComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :is_html_body, :boolean, default: false, null: false

    reversible do |dir|
      dir.up do
        transaction do
          execute "UPDATE comments SET is_html_body = 1 WHERE body like '%<p>%';"
        end
      end
    end
  end
end
