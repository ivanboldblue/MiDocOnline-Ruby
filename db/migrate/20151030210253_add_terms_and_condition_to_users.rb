class AddTermsAndConditionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :terms_and_condition, :boolean
  end
end
