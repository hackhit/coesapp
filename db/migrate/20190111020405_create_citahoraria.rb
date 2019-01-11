class CreateCitahoraria < ActiveRecord::Migration[5.2]
  def change
    create_table :citahorarias do |t|
      t.references :estudiante, type: :string, null: false
      t.datetime :fecha, null: false
      t.timestamps
    end
    add_foreign_key :citahorarias, :estudiantes, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade

  end
end
