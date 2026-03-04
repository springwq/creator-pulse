class CreateContents < ActiveRecord::Migration[8.1]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.string :social_media_url, null: false
      t.integer :social_media_provider, null: false, default: 0
      t.references :creator, null: false, foreign_key: true

      t.timestamps
    end

    add_index :contents, :social_media_provider
  end
end
