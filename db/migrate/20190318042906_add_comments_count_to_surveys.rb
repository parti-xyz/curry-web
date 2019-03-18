class AddCommentsCountToSurveys < ActiveRecord::Migration[5.0]
  def change
    add_column :surveys, :comments_count, :integer, default: 0

    reversible do |dir|
      dir.up do
        transaction do
          Survey.all.each do |survey|
            Survey.reset_counters(survey.id, :comments)
          end
        end
      end
    end
  end
end
