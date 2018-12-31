class CreateSecciones < ActiveRecord::Migration[5.2]
  def change
    create_table :secciones do |t|
      t.string :numero
      t.references :asignatura, type: :string
      t.references :periodo, type: :string
      t.references :profesor, type: :string
      t.boolean :calificada
      t.integer :capacidad

      t.timestamps
    end
    add_foreign_key :secciones, :profesores, primary_key: :usuario_id, on_delete: :cascade, on_update: :cascade, index: true
    add_foreign_key :secciones, :asignaturas, type: :string, on_delete: :cascade, on_update: :cascade, index: true

    add_foreign_key :secciones, :periodos, type: :string, on_delete: :cascade, on_update: :cascade, index: true

    add_index :secciones, [:numero, :periodo_id, :asignatura_id], unique: true

  end
end
