class CreateAdministrador < ActiveRecord::Migration[5.2]
	def change
		create_table :administradores, id: false do |t|
			t.references :usuario, null: false, type: :string, primary_key: true
			t.integer :rol, null: false
			t.references :departamento, type: :string
			t.references :escuela, type: :string
		end
		add_foreign_key :administradores, :usuarios, column: :usuario_id, primary_key: :ci, on_delete: :cascade,  on_update: :cascade
		add_foreign_key :administradores, :departamentos, type: :string, on_delete: :cascade, on_update: :cascade, index: true
		add_foreign_key :administradores, :escuelas, type: :string, on_delete: :nullify, on_update: :cascade, index: true
		
	end
end
