class AddTipoToPeriodo < ActiveRecord::Migration[5.2]
  def change
  	add_column :periodos, :tipo, :integer, null: false
  end
end
