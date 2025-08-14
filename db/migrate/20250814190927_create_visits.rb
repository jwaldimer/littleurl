class CreateVisits < ActiveRecord::Migration[8.0]
  def change
    create_table :visits do |t|
      t.references :little_url, null: false, foreign_key: true
      t.inet :ip_address
      t.string :user_agent

      t.timestamps
    end
    add_index :visits, :ip_address
  end
end
