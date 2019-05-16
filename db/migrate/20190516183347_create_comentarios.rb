class CreateComentarios < ActiveRecord::Migration[5.2]
  def change
    create_table :comentarios do |t|
      t.text :contenido
      t.boolean :publico, default: false

      t.timestamps
    end
  end
end
