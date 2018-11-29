class CreateReminders < ActiveRecord::Migration[5.2]
  def change
    create_table :reminders do |t|
      t.string :sender
      t.string :people
      t.string :message
      t.string :time

      t.timestamps
    end
  end
end
