class AddReauthEmailAtColumn < ActiveRecord::Migration
  def change
  	add_column    :shoppers, :last_reauth_email_sent_at, :datetime
  end
end
