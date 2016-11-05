class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :doctor_id
      t.integer :patient_id

      t.timestamps
    end
  end
end
