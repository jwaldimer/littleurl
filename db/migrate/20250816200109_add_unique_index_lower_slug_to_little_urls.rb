class AddUniqueIndexLowerSlugToLittleUrls < ActiveRecord::Migration[8.0]
  def change
    remove_index :little_urls, :slug if index_exists?(:little_urls, :slug)
    add_index :little_urls, "LOWER(slug)", unique: true, name: "index_little_urls_on_lower_slug"
  end
end
