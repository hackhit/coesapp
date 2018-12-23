class CreateUsuarios < ActiveRecord::Migration[5.2]
  def change
    create_table :usuarios, id: false do |t|
      t.string :ci, null: false, primary_key: true, index: true 
      t.string :nombres
      t.string :apellidos
      t.string :email
      t.string :telefono_habitacion
      t.string :telefono_movil
      t.string :password
      t.integer :sexo, null: false

      t.timestamps
    end

  end
end
