class AddSignerCountryAndSignerCityToSigns < ActiveRecord::Migration[5.0]
  def change
    add_column :signs, :signer_country, :string
    add_column :signs, :signer_city, :string
  end
end
