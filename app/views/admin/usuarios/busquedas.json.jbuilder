json.array! @usuarios.collect{|u| {id: u.id, text: u.descripcion}}#, partial: 'usuarios/usuario', as: :usuario
