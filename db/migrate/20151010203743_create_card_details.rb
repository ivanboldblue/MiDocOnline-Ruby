class CreateCardDetails < ActiveRecord::Migration
  def change
    create_table :card_details do |t|
      t.integer :patient_id
      t.string :card_type

      t.timestamps
    end
  end
end
