class CreateBonus < ActiveRecord::Migration[5.2]
  def change
    create_table :bonus do |t|
      t.integer :user_id
      t.integer :score
      t.integer :level
      t.integer :ontributor
      t.timestamps
    end
  end
end
