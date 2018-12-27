class CreateCitaHoraria < ActiveRecord::Migration[5.2]
  def change
    create_table :citas_horarias, id: false do |t|
      t.references :estudiante, primary_key: true, index: true
      t.date :fecha, null: false
      t.string :hora
    end
  end
end
