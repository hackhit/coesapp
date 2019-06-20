module ComentariosHelper

	def como_noticia comentario
		if comentario.created_at >= Date.today-1.day
			aux = "<p> "
			aux += "<span class= 'badge badge-danger'>¡Publicado hace #{distance_of_time_in_words(Time.now, comentario.created_at)}!</span> "
			aux += comentario.contenido.delete_prefix("<p>")
			return aux
		else
			return comentario.contenido
		end
	end

end
