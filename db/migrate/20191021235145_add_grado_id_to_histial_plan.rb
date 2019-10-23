class AddGradoIdToHistialPlan < ActiveRecord::Migration[5.2]
  def change
	add_reference :historialplanes, :escuela, type: :string, index: true
	add_foreign_key :historialplanes, :escuelas#, on_delete: :nullify,  on_update: :cascade 
	# add_foreign_key :historialplanes, :grados, primary_key: [:estudiante_id, :escuela_id], column: [:estudiante_id, :escuela_id]   #, on_delete: :nullify,  on_update: :cascade 

	add_index :historialplanes, [:estudiante_id, :escuela_id, :periodo_id, :plan_id], unique: true, name: 'unique_historial'
  end
end
