class MigrateStoriable < ActiveRecord::Migration[5.0]
  def change
    rename_column :stories, :project_id, :storiable_id
    add_column :stories, :storiable_type, :string

    reversible do |dir|
      dir.up do
        transaction do
          execute <<-SQL
            UPDATE stories
               SET storiable_type = 'Project'
          SQL
        end
      end
    end

    change_column_null :stories, :storiable_type, false
    add_index :stories, [:storiable_id, :storiable_type]
  end
end
