class CreateHorarios < ActiveRecord::Migration[5.2]
  def change
    create_table :horarios, id: false do |t|
      t.string :titulo
      t.references :seccion, null: false, primary_key: true, foreign_key: true
      t.timestamps
    end
  end
end
