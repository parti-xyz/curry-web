class AddImageToIssues < ActiveRecord::Migration[5.0]
  def change

    reversible do |dir|
      dir.up do
        transaction do
          add_column :issues, :image, :string
          Issue.all.each do |issue|
            issue.remote_image_url = issue.agendas.first.image_url
            issue.save(touch: false)
          end
        end
      end

      dir.down do
        transaction do
          Issue.all.each do |issue|
            issue.image = nil
            issue.save(touch: false)
          end
          remove_column :issues, :image
        end
      end
    end
  end
end
