class CreateNewsPosts < ActiveRecord::Migration
  def change
    create_table :news_posts do |t|
    	t.string :title
    	t.text :description
    	t.string :post_type
    	t.date :post_date
    	t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end
end
