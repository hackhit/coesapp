class CreateParametroGeneral < ActiveRecord::Migration[5.2]
  def change
    create_table :parametros_generales, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true 
      t.string :valor
      t.string :valor

      t.timestamps      
    end
  end
end
