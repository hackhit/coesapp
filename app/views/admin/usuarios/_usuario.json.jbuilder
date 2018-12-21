json.extract! usuario, :id, :ci, :nombres, :apellidos, :email, :telefono_habitacion, :telefono_movil, :password, :sexo, :created_at, :updated_at
json.url usuario_url(usuario, format: :json)
