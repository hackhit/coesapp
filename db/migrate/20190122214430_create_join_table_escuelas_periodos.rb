class CreateJoinTableEscuelasPeriodos < ActiveRecord::Migration[5.2]
  def change
    create_table 'escuelaperiodos' do |t|
      t.references :periodo, type: :string
      t.references :escuela, type: :string
      t.index [:escuela_id, :periodo_id], unique: true
      t.index [:periodo_id, :escuela_id], unique: true
      t.timestamps

    end
    add_foreign_key :escuelaperiodos, :escuelas, on_delete: :cascade,  on_update: :cascade
    add_foreign_key :escuelaperiodos, :periodos, on_delete: :cascade,  on_update: :cascade
  end
end
