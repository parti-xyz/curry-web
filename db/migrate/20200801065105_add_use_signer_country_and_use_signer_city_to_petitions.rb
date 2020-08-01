class AddUseSignerCountryAndUseSignerCityToPetitions < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :use_signer_country, :string, default: 'unused'
    add_column :campaigns, :use_signer_city, :string, default: 'unused'
    add_column :campaigns, :signer_country_title, :string
    add_column :campaigns, :signer_city_title, :string
  end
end
