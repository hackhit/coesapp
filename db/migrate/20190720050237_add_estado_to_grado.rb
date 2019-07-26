class AddEstadoToGrado < ActiveRecord::Migration[5.2]
  def change
  	add_column :grados, :estado, :integer, default: 0, null: false
  end
end
