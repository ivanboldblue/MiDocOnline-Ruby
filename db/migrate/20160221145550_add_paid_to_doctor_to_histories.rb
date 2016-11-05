class AddPaidToDoctorToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :paid_to_doctor, :boolean
    add_column :histories, :paid_date, :datetime
  end
end
