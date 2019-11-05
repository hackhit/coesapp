class CreateBloquehorarios < ActiveRecord::Migration[5.2]
  def change
    create_table :bloquehorarios, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer :dia
      t.time :entrada
      t.time :salida
      t.string :profesor_id
      t.references :horario

      t.timestamps
    end
    add_foreign_key :bloquehorarios, :profesores, primary_key: :usuario_id, on_delete: :nullify,  on_update: :cascade
    add_foreign_key :bloquehorarios, :horarios, primary_key: :seccion_id, on_delete: :cascade,  on_update: :cascade

    add_index :bloquehorarios, [:horario_id, :dia, :salida], unique: true 
    add_index :bloquehorarios, [:horario_id, :dia, :entrada], unique: true 
  end
end
