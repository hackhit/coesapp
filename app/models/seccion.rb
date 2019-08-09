class Seccion < ApplicationRecord

	# ASOCIACIONES:
	belongs_to :asignatura
	belongs_to :periodo
	belongs_to :tipo_seccion
	belongs_to :profesor, optional: true 
	has_one :escuela, through: :asignatura

	has_many :inscripcionsecciones, dependent: :delete_all
	accepts_nested_attributes_for :inscripcionsecciones
	has_many :estudiantes, through: :inscripcionsecciones, source: :estudiante

	has_many :secciones_profesores_secundarios,
		:class_name => 'SeccionProfesorSecundario'
	accepts_nested_attributes_for :secciones_profesores_secundarios
	has_many :profesores, through: :secciones_profesores_secundarios, source: :profesor

    # VALIDACIONES:
    validates :asignatura_id, presence: true
    # validates :profesor_id, presence: true, if: :new_record?
    validates :periodo_id, presence: true
    validates :numero, presence: true
	validates_uniqueness_of :numero, scope: [:periodo_id, :asignatura_id], message: 'La sección ya existe, inténtalo de nuevo!', field_name: false

	before_create :default_values

    # SCOPES:
    scope :trimestrales, -> {joins(:inscripcionsecciones).where("inscripcionsecciones.estado = 4 or inscripcionsecciones.estado = 5")}
    scope :trimestrales1, -> {joins(:inscripcionsecciones).where("inscripcionsecciones.estado = 4")}
    scope :trimestrales2, -> {joins(:inscripcionsecciones).where("inscripcionsecciones.estado = 5")}
	scope :calificadas, -> {where "calificada IS TRUE"}
	scope :sin_calificar, -> {where "calificada IS NOT TRUE"}
	scope :del_departamento, lambda {|dpto_id| joins(:asignatura).where('asignaturas.departamento_id = ?', dpto_id)}
	scope :del_periodo, lambda { |periodo_id| where "periodo_id = ?", periodo_id}
	# scope :del_periodo_actual, -> { where "periodo_id = ?", ParametroGeneral.periodo_actual_id}

	# FUNCIONES:

	def total_calificados
	self.inscripciones.con_calificacion.count
	end

	def notas
		self.inscripciones.each{|ins| p ins.calificacion_final}
	end

	def inscripciones
		self.inscripcionsecciones
	end

	def promedio
		self.inscripcionsecciones.average("calificacion_final").to_i#f.round(2)
	end

	def maximo
		self.inscripcionsecciones.max("calificacion_final").to_i
	end

	def habilitada_para_calificadar_recientemente?
		fecha_ultima_calificacion = Bitacora.where("tipo_objeto = 'Seccion' and id_objeto = #{self.id} and descripcion LIKE '%para calificar trimestral%'").last

		if fecha_ultima_calificacion.nil?
			return false
		else
			fecha_ultima_calificacion = fecha_ultima_calificacion.created_at
			if (fecha_ultima_calificacion + 2.week) > Date.today
				return true
			else
				return false
			end
		end
	end


	def tr_estilo_estado
		self.calificada ? 'table-success' : ''

	end

	def recientemente_calificada?
		fecha_ultima_calificacion = Bitacora.where("tipo_objeto = 'Seccion' and id_objeto = #{self.id} and descripcion LIKE '%Seccion Calificada%'").last

		if fecha_ultima_calificacion.nil?
			return false
		else
			fecha_ultima_calificacion = fecha_ultima_calificacion.created_at
			if (fecha_ultima_calificacion + 6.week) > Date.today
				return true
			else
				return false
			end
		end
	end


	def colocar_reciente_estado_calificacion

		calificada_reciente = self.recientemente_calificada?

		tipo_adicional = 'info'
		size = 11
		mensaje = 'Pendiente por calificar'
		if self.tiene? 0 # Sin Calificar
			mensaje = 'Pendiente por calificar 1er. Trimestre'
			tipo_adicional = 'warning'
		elsif self.tiene_trimestres1?
			if calificada_reciente
				mensaje = '1er. Trimestre calificado'
			else
				size = 12
				mensaje = 'Pendiente por calificar 2do. Trimestre'
				tipo_adicional = 'warning'
			end
			
		elsif self.tiene_trimestres2?
			if calificada_reciente
				mensaje = '2do. Trimestre calificado'
			else
				size = 12
				mensaje = 'Pendiente por calificar 3er. Trimestre'
				tipo_adicional = 'warning'

			end
		end
		return "<div class='badge badge-#{tipo_adicional}' style='font-size: #{size}px;'>#{mensaje}</div>"
	end


	def tiene_trimestres1?
		# self.tiene? 4
		self.inscripcionsecciones.trimestre1.any?
	end

	def tiene_trimestres2?
		# self.tiene? 5
		self.inscripcionsecciones.trimestre2.any?
	end

	def tiene? del_estado
		self.inscripcionsecciones.any? and (cuantos_tiene? del_estado).any?
	end

	def cuantos_tiene? del_estado
		self.inscripcionsecciones.group("estado").having("estado = #{del_estado}").count
	end

	def pci?
		self.asignatura.pci? self.periodo_id
	end

	def cerrada?
		!self.abierta
	end

	def abierta?
		abierta
	end

	def capacidad_vs_inscritos
		"#{self.capacidad} / #{total_estudiantes}"
	end

	def calificada_valor
		self.calificada ? 'Sí' : 'No'
	end

	def total_no_retirados
		total_estudiantes - total_retirados		
	end

	def total_estudiantes
		inscripcionsecciones.count
	end

	def total_confirmados
		inscripcionsecciones.confirmados.count
	end

	def total_aprobados
		inscripcionsecciones.aprobado.count
	end

	def total_reprobados
		inscripcionsecciones.aplazado.count
	end

	def total_retirados
		inscripcionsecciones.retirado.count
	end

	def total_perdidos
		inscripcionsecciones.perdidos.count
	end

	def total_sin_calificar
		inscripcionsecciones.sin_calificar.count
	end


	def descripcion_con_uxxi
		"(#{asignatura.id_uxxi}) - #{descripcion}"
	end


	def descripcion
		descrip = "#{self.periodo_id} - "
		descrip += self.asignatura.descripcion_pci self.periodo_id
		
		if numero
			if self.suficiencia?
				descrip += " (Suficiencia)"
			else
				descrip += " - #{numero}"
			end
		end 
		return descrip
	end

	def tabla_profesores_secundarios
		aux = "<table class='table mb-0'><tbody>"

		profesores.each do |profe|
			aux += "<tr><td>#{profe.descripcion}"
			aux += "<a data_confirm='¿Está seguro de esta acción?' href='/coesapp/secciones/#{id}/desasignar_profesor_secundario?profesor_id=13587081' class='tooltip-btn' data_toggle='tooltip' title='Desasignar este profesor'><i class='glyphicon glyphicon-minus text-danger'></i></a>"
			aux += "</td></tr>"
		end

		aux += "<tr><td><a href='/coesapp/secciones/#{id}/seleccionar_profesor?sec=true' class='tooltip-btn' data_toggle='tooltip' title='Agregar profesor secundario'><i class='glyphicon glyphicon-plus text-success'></i></a></td></tr>"

		aux += '</tbody></table>'

	end

	def descripcion_escuela
		"#{descripcion} (#{escuela.descripcion})"
	end

	# Se convirtió en un partial 
	# def descripcion_profesor_asignado_edit
		
	# 	if profesor
	# 		aux = profesor.descripcion_usuario
	# 	else
	# 		aux = "No asignado"
	# 	end

	# 	aux += " <a role='button' class='tooltip-btn' data_toggle='tooltip' title='Actualizar Tutor-Calificador' href=#{seleccionar_profesor_seccion_path(self.id)}><span class='glyphicon glyphicon-pencil'></span></a> "
	# end

	
	def descripcion_profesor_asignado
		if profesor
			profesor.descripcion_usuario
		else
			"No asignado"
		end
	end

	def ejercicio
		"#{periodo_id}"
	end

	def r_or_f?
		if numero.include? 'R'
			return 'R'
		else 
			'F'
		end
	end

	# end


	def suficiencia?
		# return numero.include? 'S'
		self.tipo_seccion_id.eql? TipoSeccion::SUFICIENCIA
	end

	def tipo_convocatoria
		"F#{self.periodo.valor_para_tipo_convocatoria}"
	end

	# def tipo_convocatoria
	# 	aux = numero[0..1]
	# 	if reparacion?
	# 		aux = "RA2" #{aux}"
	# 	else
	# 		aux = "FA2" #"F#{aux}"
	# 	end
	# 	return aux
	# end

	def acta_no
		"#{self.asignatura.id_uxxi}#{self.numero}#{self.periodo_id}"
	end

	# FUNCIONES PROTEGIDAS

	protected

	def default_values
		self.tipo_seccion_id ||= 'NF'
		self.calificada ||= false
	end

end
