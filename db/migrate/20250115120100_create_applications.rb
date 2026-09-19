class CreateApplications < ActiveRecord::Migration[7.1]
  def change
    create_table :applications do |t|
      t.references :user, null: false, foreign_key: true

      t.string :company, null: false
      t.string :role, null: false
      t.integer :status, null: false, default: 0
      t.date :applied_date, null: false
      t.text :notes

      t.timestamps
    end

    add_index :applications, [:user_id, :status]
    add_index :applications, [:user_id, :applied_date]
  end
end
