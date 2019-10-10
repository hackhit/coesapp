class CreateTableDireccion < ActiveRecord::Migration[5.2]
  def change
    create_table :direcciones, id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    	t.references :estudiante, null: false, type: :string, primary_key: true
    	t.string :estado
    	t.string :municipio
    	t.string :ciudad
    	t.string :sector
    	t.string :calle
    	t.string :tipo_vivienda
    	t.string :nombre_vivienda
    end
    add_foreign_key :direcciones, :estudiantes, column: :estudiante_id, primary_key: :usuario_id, on_delete: :cascade,  on_update: :cascade
  end
end
