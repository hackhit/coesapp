class AddVariosToEstudiante < ActiveRecord::Migration[5.2]
  def change
  	add_column :estudiantes, :discapacidad, :string
  	add_column :estudiantes, :titulo_universitario, :string
  	add_column :estudiantes, :titulo_universidad, :string
  	add_column :estudiantes, :titulo_anno, :string
  end
end
