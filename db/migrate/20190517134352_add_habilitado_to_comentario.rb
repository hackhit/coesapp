class AddHabilitadoToComentario < ActiveRecord::Migration[5.2]
  def change
  	add_column :comentarios, :habilitado, :boolean, default: true
  end
end
