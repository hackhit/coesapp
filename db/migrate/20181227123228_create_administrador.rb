class CreateAdministrador < ActiveRecord::Migration[5.2]
  def change
    create_table :administradores, id: false do |t|
      t.references :usuario, null: false, type: :string, primary_key: true
      t.integer :rol, null: false
      t.references :departamento, type: :string, foreign_key: true,  index: true
    end
    add_foreign_key :administradores, :usuarios, column: :usuario_id, primary_key: :ci, on_delete: :cascade,  on_update: :cascade
  end
end
