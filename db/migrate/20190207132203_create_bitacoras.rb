class CreateBitacoras < ActiveRecord::Migration[5.2]
  def change
    create_table :bitacoras do |t|
      t.text :comentario
      t.string :descripcion
      t.references :estudiante, type: :string
      t.references :administrador, type: :string
      t.references :profesor, type: :string
      t.references :usuario, type: :string
      t.string :ip_origen
      t.integer :tipo, default: 0

      t.timestamps
    end
    add_foreign_key :bitacoras, :estudiantes, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :bitacoras, :profesores, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :bitacoras, :administradores, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :bitacoras, :usuarios, primary_key: :ci, on_delete: :cascade,  on_update: :cascade

  end
end
