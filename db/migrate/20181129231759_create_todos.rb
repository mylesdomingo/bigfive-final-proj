class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.string :name
      t.string :sender
      t.string :people
      t.string :message
      t.string :time

      t.timestamps
    end
  end
end
