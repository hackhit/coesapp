module InscripcionSeccionHelper

	def borrar_seleccion_link asignatura_id
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: 'Borrar Seleccion' do
 			link_to "×", "javascript:void(0)", onclick: "borrar_seleccion('#{asignatura_id}');", class: 'btn btn-sm btn-danger'
		end

	end 

end
