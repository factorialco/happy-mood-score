class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :language, index: true, null:  false
      t.string :uuid, limit: 36, null: false, index: true, unique: true
      t.string :title, index: true, null: false
      t.text :summary
      t.string :permalink, index: true, null: false
      t.datetime :published_at, index: true
      t.text :content
      t.timestamps
    end
  end
end
