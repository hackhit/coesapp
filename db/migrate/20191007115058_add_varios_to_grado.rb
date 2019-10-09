class AddVariosToGrado < ActiveRecord::Migration[5.2]
  def change
  	add_column :grados, :tipo_ingreso, :integer, null: false
  	add_column :grados, :inscrito_ucv, :boolean, default: true
  	add_column :grados, :estado_inscripcion, :integer, null: false, default: 0

	add_reference :grados, :plan, index: true, type: :string
  	add_column :grados, :iniciado_periodo_id, :string, index: true

	add_foreign_key :grados, :periodos, on_delete: :nullify,  on_update: :cascade, column: "iniciado_periodo_id"
	add_foreign_key :grados, :periodos, on_delete: :nullify,  on_update: :cascade, column: "culminacion_periodo_id"


  end
end
