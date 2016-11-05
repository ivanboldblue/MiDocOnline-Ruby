class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.integer :patient_id
      t.integer :doctor_id
      t.string :chat_type

      t.timestamps
    end
  end
end
