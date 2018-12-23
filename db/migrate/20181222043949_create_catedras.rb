class CreateCatedras < ActiveRecord::Migration[5.2]
  def change
    create_table :catedras, id: false do |t|
      t.string :descripcion
      t.integer :orden
      t.string :id, null: false, primary_key: true, index: true

      t.timestamps
    end
  end
end
