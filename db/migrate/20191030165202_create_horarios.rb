class CreateHorarios < ActiveRecord::Migration[5.2]
  def change
    create_table :horarios, id: false do |t|
      t.string :titulo
      t.string :color
      t.references :seccion, null: false, primary_key: true
      t.timestamps
    end
    add_foreign_key :horarios, :secciones, column: :seccion_id, on_delete: :cascade,  on_update: :cascade

  end
end
