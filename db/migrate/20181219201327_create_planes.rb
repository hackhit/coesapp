class CreatePlanes < ActiveRecord::Migration[5.2]
  def change
    create_table :planes, id: false do |t|
      t.string :id, null: false, primary_key: true, index: true      
      t.string :descripcion

      t.timestamps
    end
  end
end
