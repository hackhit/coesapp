class RenameEscuelaestudianteToGrado < ActiveRecord::Migration[5.2]
  def change
  	rename_table :escuelaestudiantes, :grados
  end
end
