class AddColumnToCardDetails < ActiveRecord::Migration
  def change
    add_column :card_details, :validity, :string
    add_column :card_details, :cvv, :integer
    add_column :card_details, :number, :string
  end
end
