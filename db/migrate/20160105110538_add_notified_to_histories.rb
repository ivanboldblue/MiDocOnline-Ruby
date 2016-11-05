class AddNotifiedToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :notified, :boolean
  end
end
