class CreateTipoSecciones < ActiveRecord::Migration[5.2]
  def change
    create_table :tipo_secciones, id: false do |t|
      t.string :descripcion
      t.string :id, null: false, primary_key: true, index: true
      t.timestamps
    end
  end
end
