class RenameColumnsInHistories < ActiveRecord::Migration
  def change
  	rename_column :histories, :patient_id, :caller_id
  	rename_column :histories, :doctor_id, :receiver_id
  end
end
