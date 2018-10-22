class AddSubscriptionToSign < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up do
        transaction do
          add_column :signs, :subscribed, :boolean, default: true
          add_column :signs, :subscribed_at, :timestamp
          Sign.update_all "subscribed_at = created_at"
        end
      end

      dir.down do
        transaction do
          remove_column :signs, :subscribed
          remove_column :signs, :subscribed_at
        end
      end
    end
  end
end
