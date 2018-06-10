class AddAncestryToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ancestry, :string, limit: 65535
  end
end
