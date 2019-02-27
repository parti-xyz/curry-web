class AddOrdersCountToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :orders_count, :integer, default: 0
  end
end
