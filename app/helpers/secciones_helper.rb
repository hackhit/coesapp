module SeccionesHelper

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
		
		number_field_tag "[est][#{inscripcion.estudiante_id}]#{calificacion}", {}, {value: valor, placeholder: holder, class: 'form-control form-control-sm numerica3', required: required, step: 0.1, in: 0...21, readonly: readonly, onchange: onchange}
	end

	def colocar_calificacion_final inscripcion, disable = false
		calificacion_final = inscripcion.calificacion_final.nil? ? nil : sprintf("%02i", inscripcion.calificacion_final.to_i)

		number_field_tag "[est][#{inscripcion.estudiante_id}]calificacion_final", {}, {value: calificacion_final, placeholder: 'Final', class: 'form-control form-control-sm calificable', required: !disable, disabled: disable, step: 1, in: 0...21, onchange: "numero_a_letras($(this).val(), #{inscripcion.estudiante_id});", id_obj: inscripcion.id, tipo_calificacion_id: 'NF'}
		
	end

	def colocar_calificacion_absoluta inscripcion, valor, disable = false

		radio_button_tag "[est][#{inscripcion.estudiante_id}]calificacion_final", valor, (inscripcion.aprobado?), disabled: disable, onchange: "numero_a_letras('A', #{inscripcion.estudiante_id});", required: !disable, class: 'calificable', id_obj: inscripcion.id, tipo_calificacion_id: 'NF'
	end

end
