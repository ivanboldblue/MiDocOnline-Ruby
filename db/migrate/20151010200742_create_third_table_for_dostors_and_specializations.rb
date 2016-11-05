class CreateThirdTableForDostorsAndSpecializations < ActiveRecord::Migration
  def change
    create_table :specializations_users, id: false do |t|
      t.integer :doctor_id
      t.integer :specialization_id
    end
 
  end
end
