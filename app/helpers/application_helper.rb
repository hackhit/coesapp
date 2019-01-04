module ApplicationHelper
	def btn_tooltip_link_to title_tooltip, title, icon_name, btn_type, path
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: title_tooltip do
			link_to path, class: "btn #{btn_type}" do
				capture_haml{"#{glyph icon_name} #{title}"}
			end

		end
	end

	def tooltip_link_to title_tooltip, icon_name, color_type, path
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: title_tooltip do
			link_to path, class: "text-#{color_type}" do
				capture_haml{"#{glyph icon_name}"}
			end

		end
	end	

	def btn_inscribir href, title_tooltip, value
		btn_toggle 'btn-success', 'edit', href, title_tooltip, value
	end

	def btn_add_success href, title_tooltip, value
		btn_success 'plus', href, title_tooltip, value
	end

	def btn_edit_primary href, title_tooltip, value
		btn_toggle 'btn-outline-primary', 'edit', href, title_tooltip, value
	end

	def btn_success icon, href, title_tooltip, value
		btn_toggle 'btn-outline-success', icon, href, title_tooltip, value
	end

	def btn_toggle type, icon, href, title_tooltip, value, onclick_action=nil
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: title_tooltip do
			link_to href, class: "btn btn-sm #{type}", onclick: onclick_action do
				capture_haml{"#{glyph icon} #{value}"}
			end
		end
	end

	def simple_icon_toggle_modal_edit title_tooltip, id_modal
		simple_icon_toggle_modal title_tooltip, '', 'edit', id_modal
	end

	def simple_icon_toggle_modal title_tooltip, color_type, icon, id_modal
		simple_toggle 'javascript:void(0)', '', title_tooltip, color_type, icon, "$('##{id_modal}').modal();"
	end

	def simple_toggle href, value, title_tooltip, color_type, icon, onclick_action=nil
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: title_tooltip do
			link_to href, class: "text-#{color_type}", onclick: onclick_action do
				capture_haml{"#{glyph icon} #{value}"}
			end
		end

	end

	def btn_toggle_modal icon, title_tooltip, value, id_modal
		btn_toggle 'btn-outline-success', icon, 'javascript:void(0)', title_tooltip, value, "$('##{id_modal}').modal();"
	end	
end
