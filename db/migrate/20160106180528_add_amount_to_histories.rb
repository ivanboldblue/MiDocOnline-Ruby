class AddAmountToHistories < ActiveRecord::Migration
  def change
    add_column :histories, :amount, :float
    add_column :histories, :currency, :string
  end
end
