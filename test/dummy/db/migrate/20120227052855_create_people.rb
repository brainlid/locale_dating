class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.date :born_on
      t.datetime :last_seen_at
      t.time :start_time

      t.timestamps
    end
  end
end
