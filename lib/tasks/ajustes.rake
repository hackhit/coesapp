desc "Actualizacion de inscripciones_secciones a la estructura nueva"
task :ajuste_inscripcionsecciones => :environment do
	puts 'Iniciando Ajuste a Inscripciones Secciones con valores en TipoEstadoCalificacion...'
	begin
		puts 'Iniciando...'

		inscrip = Inscripcionseccion.where("tipo_estado_calificacion_id IS NOT NULL")
		total_ins = inscrip.count

		total_pi = 0
		total_a = 0
		total_ap = 0
		total_ret = 0

		p "=".center(180, "=")
		p "=".center(180, "=")
		p "   INICIO:   ".center(180, "=")
		p "     TOTAL_INS: #{total_ins}.    ".center(180, "=")
		p "     TOTAL_PI: #{total_pi}.    ".center(180, "=")
		p "     TOTAL_A: #{total_a}.    ".center(180, "=")
		p "     TOTAL_AP: #{total_ap}.    ".center(180, "=")
		p "     TOTAL_RET: #{total_ret}.    ".center(180, "=")
		p "=".center(180, "=")
		p "=".center(180, "=")

		inscrip.each do |ins|
			# p ins 
			if ins.tipo_estado_calificacion_id.eql? 'PI' and ins.calificacion_final == 0
		 		print "-PI-"
				ins.tipo_estado_calificacion_id = nil
			 	ins.tipo_calificacion_id = 'PI'
		 		ins.estado = :aplazado
		 		total_pi += 1
				print '.' if ins.save
			elsif ins.tipo_estado_calificacion_id.eql? 'A' and ins.estado.eql? 'sin_calificar'
		 		print "-A-"
				ins.tipo_estado_calificacion_id = nil
				ins.tipo_calificacion_id = 'NF'
				ins.estado = :aprobado
				total_a += 1
				print '.' if ins.save
			elsif ins.tipo_estado_calificacion_id.eql? 'AP' and ins.estado.eql? 'sin_calificar'
		 		print "-AP-"
				ins.tipo_estado_calificacion_id = nil
				ins.tipo_calificacion_id = 'NF'
				ins.estado = :aplazado
				total_ap += 1
				print '.' if ins.save
			elsif ins.tipo_estado_inscripcion_id.eql? 'RET' and ins.tipo_calificacion_id.nil? and ins.estado.eql? 'sin_calificar'
		 		print "-RET-"
				ins.tipo_estado_calificacion_id = nil
				ins.tipo_calificacion_id = 'NF'
				ins.estado = :retirado
				total_ret += 1
				print '.' if ins.save
			else
				print "x"
			end


		end
		p ' Vamos con la secciones '.center(180, "=")
		secciones = inscrip.group(:seccion_id).count
		p "inicio de secciones"
		secciones.each_pair do |k,v|
			s = Seccion.find k
			s.abierta = false
			print "s" if s.save
		end
		p "fin de secciones"


		p "=".center(180, "=")
		p "=".center(180, "=")
		p "   RESULTADOS:   ".center(180, "=")
		p "     TOTAL_INS: #{total_ins}.    ".center(180, "=")
		p "     TOTAL_PI: #{total_pi}.    ".center(180, "=")
		p "     TOTAL_A: #{total_a}.    ".center(180, "=")
		p "     TOTAL_AP: #{total_ap}.    ".center(180, "=")
		p "     TOTAL_RET: #{total_ret}.    ".center(180, "=")
		p "=".center(180, "=")
		p "=".center(180, "=")

	rescue Exception => e
		p = "Error: #{e.message}"
	end
end


desc "Genera las programaciones de todos los periodos si las asignaturas tiene al menos una seccion"
task :generar_programaciones => :environment do
	p 'Iniciando generación de programaciones...'
	begin
		p 'Iniciando...'
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

