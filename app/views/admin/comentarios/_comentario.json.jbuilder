json.extract! comentario, :id, :contenido, :publico, :created_at, :updated_at
json.url comentario_url(comentario, format: :json)
