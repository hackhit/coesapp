module SeccionesHelper

	def colocar_etiqueta valor, tipo, tooltip_title = nil
		capture_haml do 
			colocar_badge valor, tipo, tooltip_title
		end
	end

	def colocar_badge valor, tipo, tooltip_title = nil
		if tooltip_title
			haml_tag :span, class: "badge badge-#{tipo} tooltip-btn", 'data_toggle': :tooltip, title: tooltip_title do
				haml_concat "#{valor}"
			end
		else
			haml_tag :span, class: "badge badge-#{tipo}" do haml_concat valor end
		end

	end

	def colocar_etiqueta_califida seccion
		if seccion.calificada
			colocar_etiqueta 'Sí', 'success'
		else
			colocar_etiqueta 'No', 'danger'
		end
	end

	def colocar_estado_seccion seccion
		if seccion.calificada
			return colocar_numeros_seccion seccion
		elsif seccion.asignatura.numerica3?
			return colocar_reciente_estado_calificacion seccion
		else
			return colocar_por_calificar seccion
		end

	end

	def colocar_numeros_seccion seccion
		capture_haml do
			colocar_badge 'Calificada', 'secondary'
			colocar_badge seccion.total_estudiantes, 'info', 'Inscritos'
			colocar_badge seccion.total_aprobados, 'success', 'Aprobados'
			colocar_badge seccion.total_reprobados, 'danger', 'Aplazados'
			colocar_badge seccion.total_retirados, 'secondary', 'Retirados'
		end

	end

	def colocar_por_calificar seccion
		capture_haml do
			colocar_badge 'Por Calificar', 'info'
			colocar_badge seccion.total_sin_calificar, 'dark', 'Estudiantes Por Calificar'
		end
		
	end


	def colocar_reciente_estado_calificacion seccion

		calificada_reciente = seccion.recientemente_calificada?

		tipo_adicional = 'info'

		mensaje = 'Por calificar'
		if seccion.tiene? 0 # Sin Calificar
			mensaje = 'Por calificar 1er. Trimestre'
			tipo_adicional = 'warning'
		elsif seccion.tiene_trimestres1?
			if calificada_reciente
				mensaje = '1er. Trimestre calificado'
			else
				mensaje = 'Por calificar 2do. Trimestre'
				tipo_adicional = 'warning'
			end
			
		elsif seccion.tiene_trimestres2?
			if calificada_reciente
				mensaje = '2do. Trimestre calificado'
			else
				mensaje = 'Por calificar 3er. Trimestre'
				tipo_adicional = 'warning'

			end
		end

		colocar_etiqueta mensaje, tipo_adicional
		
	end

	def colocar_calificacion_parcial inscripcion, holder, calcular = false, p1 = 30, p2 = 30, p3 = 30, readonly = false, required = true
		onchange = calcular ? "calcular(#{p1}, #{p2}, #{p3}, #{inscripcion.estudiante_id});" : ""
		case holder
		when '1ra'
			valor = inscripcion.primera_calificacion
			calificacion = 'primera_calificacion'
		when '2da'
			valor = inscripcion.segunda_calificacion
			calificacion = 'segunda_calificacion'
		else
			valor = inscripcion.tercera_calificacion
			calificacion = 'tercera_calificacion'
		end 
		
		number_field_tag "[est][#{inscripcion.estudiante_id}]#{calificacion}", {}, {value: valor, placeholder: holder, class: 'form-control form-control-sm numerica3', required: required, step: 0.1, in: 0...21, readonly: readonly, disabled: readonly, onchange: onchange, id_obj: inscripcion.id, tipo_calificacion_id: TipoCalificacion::PARCIAL, calificacion_parcial: calificacion}
	end

	def colocar_calificacion_final inscripcion, disable = false
		calificacion_final = inscripcion.calificacion_final.nil? ? nil : sprintf("%02i", inscripcion.calificacion_final.to_i)

		number_field_tag "[est][#{inscripcion.estudiante_id}]calificacion_final", {}, {value: calificacion_final, placeholder: 'Final', class: 'form-control form-control-sm calificable', required: !disable, disabled: disable, step: 1, in: 0...21, onchange: "numero_a_letras($(this).val(), #{inscripcion.estudiante_id});", id_obj: inscripcion.id, tipo_calificacion_id: 'NF'}
		
	end

	def colocar_calificacion_absoluta inscripcion, valor, disable = false
		
		if valor.eql? 1
			letras = 'APROBADO'
			check = inscripcion.aprobado? ? true : false
		else
			letras = 'APLAZADO'
			check = inscripcion.aplazado? ? true : false
		end
		# letras = (valor.eql? 1) ? 'APROBADO' : 'APLAZADO'

		radio_button_tag "[est][#{inscripcion.estudiante_id}]calificacion_final", valor, check, disabled: disable, required: !disable, class: 'absoluta calificable', id_obj: inscripcion.id, tipo_calificacion_id: 'NF', ci: inscripcion.estudiante_id, final: letras
	end

end
