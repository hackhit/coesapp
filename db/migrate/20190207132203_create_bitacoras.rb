class CreateBitacoras < ActiveRecord::Migration[5.2]
  def change
    create_table :bitacoras do |t|
      t.text :comentario
      t.string :descripcion
      t.references :usuario, type: :string
      t.string :id_objeto
      t.string :tipo_objeto
      t.string :ip_origen
      t.integer :tipo, default: 0

      t.timestamps
    end

  end
end
