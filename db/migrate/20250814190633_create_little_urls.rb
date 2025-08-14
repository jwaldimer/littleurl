class CreateLittleUrls < ActiveRecord::Migration[8.0]
  def change
    create_table :little_urls do |t|
      t.string :original_url
      t.string :token
      t.string :creator_id
      t.text :description

      t.timestamps
    end
    add_index :little_urls, :token
    add_index :little_urls, :creator_id
  end
end
