class NewsPost < ActiveRecord::Base

  validates :title, :description, :post_type, 
            :presence =>true 

	has_attached_file :image, {:styles => {:large => "1200x700>", :medium => "800x440>", :blog_medium => "292x140>", :small => "200x150>", :thumb => "60x60>" }}.merge(NEWS_IMAGE_PATH)
  do_not_validate_attachment_file_type :image

  def thumb_image_url
  	self.image.url(:thumb)
  end

  def large_image_url
  	self.image.url(:large)
  end

  def small_image_url
  	self.image.url(:small)
  end

end
