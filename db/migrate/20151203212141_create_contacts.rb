class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :country_code
      t.string :mobile_no
      t.text :message

      t.timestamps
    end
  end
end
