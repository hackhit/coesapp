json.secciones_length @secciones.count
if @controller and @controller.eql? 'inscripcionsecciones'
	json.th (json.partial! '/admin/inscripcionsecciones/secciones_inscripcion.html.haml', locals: {object: @objeto, secciones: @secciones})
else
	json.th (json.partial! '/admin/secciones/index2/th_resultado.html.haml', locals: {object: @objeto, secciones: @secciones})

end

