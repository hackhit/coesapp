class CreateRestringidas < ActiveRecord::Migration[5.2]
  def change
    create_table :restringidas, options: "ENGINE=InnoDB CHARSET=utf8" do |t|
      t.boolean :acceso_total, default: false
      t.string :nombre_publico, null: false
      t.string :controlador, null: false
      t.string :accion, null: false
      t.integer :grupo, null: false
      t.index :nombre_publico, unique: true
      t.index [:controlador, :accion], unique: true

      t.timestamps
    end
  end
end
