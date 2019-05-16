class CambioEnComentario < ActiveRecord::Migration[5.2]
  def change
  	remove_column :comentarios, :publico
  	add_column :comentarios, :estado, :integer, default: 0
  end
end
