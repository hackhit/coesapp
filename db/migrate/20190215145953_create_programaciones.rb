class CreateProgramaciones < ActiveRecord::Migration[5.2]
  def change
    create_table :programaciones, id: false do |t|
      t.references :asignatura, type: :string, foreign_key: true, index: true
      t.references :periodo, type: :string, foreign_key: true, index: true
      t.index [:asignatura_id, :periodo_id], unique: true
      t.index [:periodo_id, :asignatura_id], unique: true

      t.timestamps
    end
  end
end
