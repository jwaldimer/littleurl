class AddSlugToLittleUrls < ActiveRecord::Migration[8.0]
  def change
    add_column :little_urls, :slug, :string
    add_index :little_urls, :slug, unique: true
  end
end
