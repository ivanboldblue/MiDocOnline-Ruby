class Payment < ActiveRecord::Base
  belongs_to :user
  

  validates :amount, 
            :presence => true 
  validates :user_id,
            :presence => true
  validates :payment_date, 
            :presence => true 
  validates :txnid,
            :presence => true
  validates :status,
            :presence => true
end
