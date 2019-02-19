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

desc "Genera las programaciones del periodo 2019-01S de las asignaturas activas"
task :generar_programaciones_201901S => :environment do
	puts 'Iniciando generación de programaciones...'
	begin
		creadas = 0
		existentes = 0
		pe = Periodo.last

		pe.asignaturas.where("activa IS TRUE").each do |a| 
			if a.programaciones.find_by(periodo_id: pe.id)
				existentes += 1
				p 'x'
			elsif a.programaciones.create(periodo_id: pe.id)
				creadas = 0
				p '.' 
			end

		end


		puts "Total de programaciones creadas: #{creadas}. Existente: #{existentes}"
	rescue Exception => e
		puts = "Error: #{e.message}"
	end
end

desc 'Migrar Estudiantes a EscuelaEstudiante'
task estudiantes_a_escuela_estudiantes: :environment do
	p 'Iniciando migracion de Estudiante a EscuelaEstudiante'

	Estudiante.all.each do |es|
		if es.escuela_id
			print '.' if es.escuelaestudiantes.create!(escuela_id: es.escuela_id)
		end
	end

	p "Total de nuevos EscuelaEstudiantes Creados: #{Escuelaestudiante.count}"

end

