class AddColumnToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :qb_caller_id, :string
    add_column :histories, :qb_receiver_id, :string
  end
end
