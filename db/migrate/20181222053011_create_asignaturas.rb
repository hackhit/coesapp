class CreateAsignaturas < ActiveRecord::Migration[5.2]
  def change
    create_table :asignaturas, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true
      t.string :descripcion
      t.integer :anno
      t.integer :orden
      t.integer :calificacion, default: 0
      t.boolean :activa, default: false
      t.references :departamento, type: :string, null: false
      t.references :catedra, type: :string, null: false
      t.references :tipoasignatura, type: :string, null: false
      t.string :id_uxxi
      t.integer :creditos

      t.timestamps
    end
    add_foreign_key :asignaturas, :catedras, type: :string, on_delete: :cascade, on_update: :cascade, index: true
    add_foreign_key :asignaturas, :departamentos, type: :string, on_delete: :cascade, on_update: :cascade, index: true
    add_foreign_key :asignaturas, :tipoasignaturas, type: :string, on_delete: :cascade, on_update: :cascade, index: true

  end
end
