class AddUniqueIndexOnLowerTokenToLittleUrls < ActiveRecord::Migration[8.0]
  def change
    remove_index :little_urls, :token if index_exists?(:little_urls, :token)
    add_index :little_urls, "LOWER(token)", unique: true, name: "index_little_urls_on_lower_token"
  end
end
