class CreateTransfers < ActiveRecord::Migration[5.1]
  def change
    create_table :transfers do |t|
      t.references :calls
      t.string :transferred_from
      t.string :tranferred_to
      t.timestamps
    end
  end
end
