class CreateCarteleras < ActiveRecord::Migration[5.2]
  def change
    create_table :carteleras do |t|
      t.text :contenido
      t.boolean :activa, default: false
      t.timestamps
    end
  end
end
