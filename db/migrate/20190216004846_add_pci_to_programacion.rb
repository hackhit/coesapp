class AddPciToProgramacion < ActiveRecord::Migration[5.2]
  def change
	add_column :programaciones, :pci, :boolean, null: false, default: false
  end
end
