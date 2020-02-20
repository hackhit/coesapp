class CreateJoinTableRestringidaPerfil < ActiveRecord::Migration[5.2]
  def change
    create_join_table :restringidas, :perfiles do |t|
      t.index [:restringida_id, :perfil_id], unique: true
      # t.index [:perfil_id, :restringida_id]
    end
	add_foreign_key :perfiles_restringidas, :perfiles, on_delete: :cascade,  on_update: :cascade, name: 'perfiles_restringidas_perfile_id_fk'
	add_foreign_key :perfiles_restringidas, :restringidas, on_delete: :cascade,  on_update: :cascade, name: 'perfiles_restringidas_restringida_id_fk'
  end
end
