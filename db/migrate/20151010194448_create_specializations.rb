class CreateSpecializations < ActiveRecord::Migration
  def change
    create_table :specializations do |t|
      t.string :specialization_type
      t.string :name

      t.timestamps
    end
  end
end
