json.extract! seccion, :numero, :tipo_seccion_id
json.asignatura seccion.asignatura.descripcion_id
json.profesor (json.partial! '/admin/secciones/descripcion_profesor_asignado_edit.html.haml', locals: {seccion: seccion})
json.profesores (json.partial! '/admin/secciones/tabla_profesores_secundarios.html.haml', locals: {seccion: seccion})
json.capacidad (json.partial! '/admin/secciones/cambiar_capacidad.html.haml', locals: {seccion: seccion})
json.estado (json.partial! '/admin/secciones/estado.html.haml', locals: {seccion: seccion})
json.opciones (json.partial! '/admin/secciones/panel_detalle_opciones.html.haml', locals: {seccion: seccion})

