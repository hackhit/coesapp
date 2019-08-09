json.secciones_length @secciones.count
json.th (json.partial! '/admin/secciones/index2/th_resultado.html.haml', locals: {object: @objeto, secciones: @secciones})

