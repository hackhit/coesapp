class Estudiante < ApplicationRecord
	# ASOCIACIONES:
	belongs_to :usuario, foreign_key: :usuario_id 
	belongs_to :tipo_estado_inscripcion
	belongs_to :escuela
	belongs_to :citahoraria, optional: true

	has_many :historialplanes	
	accepts_nested_attributes_for :historialplanes
	has_many :planes, through: :historialplanes, source: :plan

	has_many :inscripcionsecciones
	accepts_nested_attributes_for :inscripcionsecciones
	
	has_many :secciones, through: :inscripcionsecciones, source: :seccion

	has_many :combinaciones, dependent: :delete_all
	accepts_nested_attributes_for :combinaciones

	# TRIGGERS
	after_initialize :set_default, :if => :new_record?
	# VALIDACIONES:
	validates :usuario_id, presence: true, uniqueness: true

	# SCOPES:
	scope :con_cita_horaria, -> {where "citahoraria_id IS NOT NULL"}

	# FUNCIONES:
	def inactivo? periodo_id
	# OJO: ESTA FUNCION DEBE CAMBIAR AL AGREGAR LA TABLA INSCRIPCION PERIDO!!!
		total_asignaturas = (self.inscripcionsecciones.del_periodo periodo_id).count
		total_retiradas = (self.inscripcionsecciones.del_periodo periodo_id).where(tipo_estado_inscripcion_id: TipoEstadoInscripcion::RETIRADA).count
		(total_asignaturas > 0 and total_asignaturas == total_retiradas)
	end

	def inscrito? periodo_id
		(inscripcionsecciones.del_periodo(periodo_id)).count > 0
	end

	def valido_para_inscribir? periodo_id
		!(inscrito? periodo_id)
	end

	def ultimo_plan
		hp = historialplanes.order("periodo_id DESC").first
		hp ? hp.plan_id : ""
	end

	def annos
		self.secciones.collect{|s| s.asignatura.anno}.uniq
	end
	def annos_del_semestre_actual
		inscripcionsecciones.del_semestre_actual.collect{|s| s.seccion.asignatura.anno}.uniq
	end

	def combo_idiomas
		aux = ""
		aux += "#{idioma1.descripcion}" if idioma1
		aux += " - #{idioma2.descripcion}" if idioma2

		aux = "Sin Idiomas Registrados" if aux.eql? ""

		return aux 
	end

	def descripcion 
		usuario.descripcion
	end


	def archivos_disponibles_para_descarga
		secciones_aux = secciones.where(periodo_id: ParametroGeneral.periodo_actual.periodo_anterior.id)

		archivos = []
		annos = []
		if secciones_aux.all.count > 0

			# Selecciono los posibles niveles

			reprobadas = 0

			# joins_seccion_materia = secciones_aux.select("seccion.*, asignatura.*").joins(:asignatura)
			secciones_aux.select("seccion.*, asignatura.*").joins(:asignatura).group("asignatura.anno").each{|x| annos << x.anno if x.anno > 0}


			inscripcionsecciones.reject{|in_se| in_se.seccion.numero.eql? 'R'}.each do |est_sec|
				
				if est_sec.calificacion_final and est_sec.calificacion_final < 10
					reparacion = inscripcionsecciones.en_reparacion.first

					if reparacion
						reprobadas = reprobadas + 1 if reparacion.calificacion_final < 10
					else
						reprobadas = reprobadas + 1
					end 
				end
				# break if reprobadas > 1	
			end
			begin
				
				if annos.count.eql? 1
					if reprobadas.eql? 0 
						annos[0] = annos[0]+1 if annos.first < 5 
					else
						annos << annos.first+1 if annos.first < 5
					end
				else

					aux = secciones_aux.where('calificacion_final < ? ', 10)
					menor_anno = aux.select("seccion.*, asignatura.*").joins(:asignatura).where(' asignatura.anno = ?', annos.min).all
					annos.delete annos.min if menor_anno.count.eql? 0
					
					mayor_anno = aux.select("seccion.*, asignatura.*").joins(:asignatura).where(' asignatura.anno = ?', annos.max).all.count
					if mayor_anno.eql? 0
						total_materias = CalMateria.where(:anno => annos.max).count
						if total_materias.eql? secciones_aux.joins(:asignatura).where('asignatura.anno = ?', annos.max).all.count
							if annos.max<5
								annos << annos.max+1
								# annos.delete annos.max
							end
						end

					end
					
					annos << annos.last+1 if (reprobadas < 2 and annos.max<5)

				end

			rescue Exception => e
				annos << 1 << 2 << 3 << 4 << 5
			end

		else

			if cal_tipo_estado_inscripcion_id.eql? 'NUEVO'
				annos << 1
			else
				annos << 1 << 2 << 3 << 4 << 5
			end
		end

		# Selecciono los posibles idiomas

		if idioma1.nil? and idioma2.nil?
			annos.each do |anno|
				archivos << "FRA-ALE-#{anno}"
				archivos << "FRA-ITA-#{anno}"
				archivos << "FRA-POR-#{anno}"
				archivos << "ING-ALE-#{anno}"
				archivos << "ING-FRA-#{anno}"
				archivos << "ING-ITA-#{anno}"
				archivos << "ING-POR-#{anno}"
			end
		else 
			ni_ingles_ni_frances = false

			unless (idioma1.id.eql? 'ING' or idioma1.id.eql? 'FRA') or (idioma2.id.eql? 'ING' or idioma2.id.eql? 'FRA')

				idiomas = "ING-#{idioma1.id}-"
				idiomas_2 = "ING-#{idioma2.id}-"
				idiomas_3 = "FRA-#{idioma1.id}-"
				idiomas_4 = "FRA-#{idioma2.id}-"
				ni_ingles_ni_frances = true
			else
				idiomas = "#{idioma1.id}-#{idioma2.id}-"
			end

			# Compilo los archivos en relacion idiomas niveles

			annos.each{|ano| archivos << idiomas+ano.to_s}

			if ni_ingles_ni_frances
				annos.each{|ano| archivos << idiomas_2+ano.to_s}
				annos.each{|ano| archivos << idiomas_3+ano.to_s}
				annos.each{|ano| archivos << idiomas_4+ano.to_s}
			end
		end
		# puts "AÑÑÑÑÑOOOOOOOOOOSSSSS antes del retorno: #{annos}"

		return archivos
	end # Fin de funcion archivos_disponibles_para_descarga

	def idioma1
		combis = combinaciones.last
		if combis
			return combis.idioma1
		else
			return nil
		end
	end

	def idioma2
		combis = combinaciones.last
		if combis
			return combis.idioma2
		else
			return nil
		end
	end

	protected

	def set_default
		self.tipo_estado_inscripcion_id ||= 'NUEVO'	
	end	

end
