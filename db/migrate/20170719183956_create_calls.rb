class CreateCalls < ActiveRecord::Migration[5.1]
  def change
    create_table :calls do |t|
      t.string    :twilio_sid
      t.string    :audio_url
      t.string    :status

      t.string    :called_number
      t.string    :called_country, default: nil
      t.string    :called_zip, default: nil
      t.string    :called_city, default: nil

      t.string    :caller_number
      t.string    :caller_country, default: nil
      t.string    :caller_zip, default: nil
      t.string    :caller_city, default: nil

      t.integer   :duration
      t.datetime  :opened_at
      t.datetime  :closed_at
      t.timestamps
    end
  end
end
