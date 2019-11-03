class AddAdditionalMailingResultToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :mailing_result_timestamp, :string
    add_column :orders, :mailing_result_recipient, :string
  end
end
