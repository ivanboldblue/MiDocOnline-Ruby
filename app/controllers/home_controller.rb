class HomeController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }
  skip_before_filter :load_filter, :only => ["search_fleets", "index", "thank_you", "empty_legs", "contactus", 'book_discounted_flifts']
  layout 'users'
  def index
    @blogpost = NewsPost.where(:post_type => 'blog').last(3)
    @posts = NewsPost.where(:post_type => 'news').order('created_at desc')
  end

  def login
  	if !(user_signed_in?)
	  	@resource = User.new
	  	render '/home/users_sign_in'
    else
      url = after_sign_in_path_for(current_user)
      redirect_to url
    end
  end
end
