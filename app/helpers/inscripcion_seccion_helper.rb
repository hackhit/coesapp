module InscripcionSeccionHelper

	def borrar_seleccion_link asignatura_id
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: 'Borrar Seleccion' do
 			link_to "×", "javascript:void(0)", onclick: "borrarSeleccion('#{asignatura_id}');", class: 'badge badge-danger', id: "borrarSeleccion#{asignatura_id}"
		end

	end 

end
