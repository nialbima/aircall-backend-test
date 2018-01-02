class AddIndexToCalls < ActiveRecord::Migration[5.1]
  def change
    add_index :calls, :twilio_sid, using: :btree
  end
end
