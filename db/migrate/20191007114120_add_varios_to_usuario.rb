class AddVariosToUsuario < ActiveRecord::Migration[5.2]
  def change

  	add_column :usuarios, :nacionalidad, :integer
  	add_column :usuarios, :estado_civil, :integer
  	add_column :usuarios, :fecha_nacimiento, :date
  	add_column :usuarios, :pais_nacimiento, :string
  	add_column :usuarios, :ciudad_nacimiento, :string
  	
  end
end
