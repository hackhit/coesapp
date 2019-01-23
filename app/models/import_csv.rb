
class ImportCsv

	# def self.preview url
		
	# 	require 'csv'    

	# 	csv_text = File.read(url)
		
	# 	return CSV.parse(csv_text, headers: true)
	# end

	def self.importar_de_archivo url, objecto
		
		require 'csv'

		csv_text = File.read(url)
		total = 0
		# csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|
		csv = CSV.parse(csv_text, headers: true)
			csv.each do |row|
				s = Seccion.all.where(numero: row.field(1), periodo_id: row.field(2), asignatura_id: row.field(3)).first 
				row.delete(1)
				row.delete(1)
				row.delete(1)
				row << {seccion_id: s.id}
				# p "Seccion ID: #{s.id} #{row.to_hash} #{row.field('')}"

				if objecto.camelize.constantize.create!(row.to_hash)
				 	total += 1
				end
			end
		return total

	end

	def self.importar_de_archivo_profesor_secundario url, objecto
		
		require 'csv'

		csv_text = File.read(url)
		total = 0
		# csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|
		csv = CSV.parse(csv_text, headers: true)
			csv.each do |row|
				s = Seccion.all.where(numero: row.field(2), periodo_id: row.field(0), asignatura_id: row.field(1)).first 
				# p "Seccion ID: #{s.id} #{row.field(0)} - #{row.field(1)} - #{row.field(2)}"
				if objecto.camelize.constantize.create!(profesor_id: row.field(3), seccion_id: s.id)
				 	total += 1
				end
			end
		return total

	end

end