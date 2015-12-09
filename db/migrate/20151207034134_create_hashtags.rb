class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :tag
      t.integer :tweet_id

      t.timestamps null: false
    end
  end
end
