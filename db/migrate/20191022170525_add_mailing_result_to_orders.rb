class AddMailingResultToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :mailing_result_type, :string
    add_column :orders, :mailing_result_subtype, :string
  end
end
