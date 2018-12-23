class CreateAdministradores < ActiveRecord::Migration[5.2]
  def change
    create_table :administradores, id: false  do |t|
      # t.string :id, null: false, primary_key: true
      t.integer :rol, null: false
      t.references :usuario, null: false, type: :string, primary_key: true
      # t.references :id, index: true, foreign_key: {to_table: :usuarios}, null: false, type: :string
    end
	add_foreign_key :administradores, :usuarios, column: :usuario_id, primary_key: :ci, on_delete: :cascade,  on_update: :cascade
    # reversible do |direction|
    #   direction.up { execute('ALTER TABLE administradores ADD PRIMARY KEY (`id`);')}
    # end	
  end
end
