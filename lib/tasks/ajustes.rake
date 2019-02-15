desc "Genera las programaciones de todos los periodos si las asignaturas tiene al menos una seccion"
task :generar_programaciones => :environment do
	puts 'Iniciando generación de programaciones...'
	begin
		puts 'Iniciando...'
		total = 0
		Periodo.all.each do |pe|
			pe.escuelas.each do |e|
				e.asignaturas.each do |a|
					if a.secciones.where(periodo_id: pe.id).count > 0
						if a.programaciones.create(periodo_id: pe.id)
							total += 1
							p '.'
						end
					end
				end
			end
		end

		puts "Total de programaciones creadas: #{total}."
	rescue Exception => e
		puts = "Error: #{e.message}"
	end
end



