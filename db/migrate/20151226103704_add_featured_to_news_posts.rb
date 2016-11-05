class AddFeaturedToNewsPosts < ActiveRecord::Migration
  def change
    add_column :news_posts, :featured, :boolean
  end
end
