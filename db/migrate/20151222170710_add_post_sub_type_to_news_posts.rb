class AddPostSubTypeToNewsPosts < ActiveRecord::Migration
  def change
  	add_column :news_posts, :post_sub_type, :string
  end
end
