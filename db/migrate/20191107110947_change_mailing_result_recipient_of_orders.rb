class ChangeMailingResultRecipientOfOrders < ActiveRecord::Migration[5.0]
  def up
    change_column :orders, :mailing_result_recipient, :text
  end
  def down
    change_column :orders, :mailing_result_recipient, :string
  end
end
