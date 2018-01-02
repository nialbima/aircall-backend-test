class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
      t.string    :from
      t.string    :twilio_sid
      t.string    :audio_url
      t.integer   :transfer_count
      t.integer   :duration

      t.datetime :opened_at
      t.datetime :closed_at
      t.timestamps
    end
  end
end
