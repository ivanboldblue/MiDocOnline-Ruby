class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :patient_id
      t.string :payment_type
      t.float :amount
      t.datetime :payment_date
      t.string :txnid
      t.string :status

      t.timestamps
    end
  end
end
