class CreatePlanes < ActiveRecord::Migration[5.2]
  def change
    create_table :planes, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true      
      t.string :descripcion
      t.references :escuela, type: :string, null: false
      t.timestamps
    end
    add_foreign_key :planes, :escuelas, type: :string, on_delete: :cascade, on_update: :cascade, index: true

  end
end
