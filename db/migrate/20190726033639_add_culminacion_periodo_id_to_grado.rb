class AddCulminacionPeriodoIdToGrado < ActiveRecord::Migration[5.2]
  def change
  	add_column :grados, :culminacion_periodo_id, :string, index: true
  end
end
