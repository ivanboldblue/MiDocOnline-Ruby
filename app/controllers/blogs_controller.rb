class BlogsController < ApplicationController

  layout 'users'
  def index
    @left_posts = NewsPost.where('post_sub_type IN (?) and post_type = ? and featured = ?', ['technology', 'health', 'software'], 'blog', false).to_a
    @popular_posts = NewsPost.where('post_sub_type IN (?) and post_type = ? and featured = ?', ['popular'], 'blog', false).to_a
    @editors_posts = NewsPost.where('post_sub_type IN (?) and post_type = ? and featured = ?', ['editors_pick'], 'blog', false).to_a
    @featuredpost = NewsPost.where(:featured => true).last
  end
end
