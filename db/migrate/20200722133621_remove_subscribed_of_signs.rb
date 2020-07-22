class RemoveSubscribedOfSigns < ActiveRecord::Migration[5.0]
  def change
    remove_column :signs, :subscribed
    remove_column :signs, :subscribed_at
  end
end
