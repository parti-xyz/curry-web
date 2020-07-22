class AddApiSecureKeyToCampaigns < ActiveRecord::Migration[5.0]
  class Campaign < ActiveRecord::Base
  end
  def change
    add_column :campaigns, :api_secure_key, :string

    Campaign.all.each do |campaign|
      campaign.update_columns(api_secure_key: SecureRandom.base64(30))
    end
  end
end
