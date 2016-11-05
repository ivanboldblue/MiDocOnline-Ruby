class AddColumnsToHistories < ActiveRecord::Migration
  def change
  	add_column :histories, :started_time, :datetime
  	add_column :histories, :duration, :float
  	add_column :histories, :chat_type, :string
  	add_column :histories, :call_status, :string
  end
end
