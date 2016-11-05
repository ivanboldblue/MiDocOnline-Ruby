class Contact < ActiveRecord::Base
	validates :name,
            :presence =>true
	validates :email, 
            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i,
            :message=> "Please check email id" },
            :presence =>true 
  validates :message,
            :presence =>true
end
