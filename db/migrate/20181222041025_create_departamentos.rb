class CreateDepartamentos < ActiveRecord::Migration[5.2]
  def change
    create_table :departamentos, id: false do |t|
      t.string :descripcion
      t.string :id, null: false, primary_key: true, index: true 
      t.references :escuela, type: :string, null: false
      t.timestamps
    end
    add_foreign_key :departamentos, :escuelas, type: :string, on_delete: :cascade, on_update: :cascade, index: true

  end
end
