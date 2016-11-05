class AddMessageToChats < ActiveRecord::Migration
  def change
    add_column :chats, :message, :text
    add_column :chats, :history_id, :integer
    add_column :chats, :user_id, :integer
  end
end
