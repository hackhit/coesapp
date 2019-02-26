json.partial! "/admin/asignaturas/asignatura", asignatura: @asignatura
json.secciones @asignatura.secciones.del_periodo(current_periodo.id) do |seccion|
	json.partial! "/admin/secciones/seccion", seccion: seccion
end
