class CardDetail < ActiveRecord::Base
  belongs_to :user
  
  validates :number, 
            :presence => true 
            
  validates :user_id,
            :presence => true


end
