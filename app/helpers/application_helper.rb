module ApplicationHelper

	def btn_tooltip_link_to title_tooltip, title, icon_name, btn_type, path
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: title_tooltip do
			link_to path, class: "btn #{btn_type}" do
				content_tag(:span, title, class: "glyphicon glyphicon-#{icon_name}")
			end

		end
	end

	def tooltip_link_to title_tooltip, icon_name, color_type, path
			
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: title_tooltip do
			link_to path, class: "text-#{color_type}" do
				content_tag(:span, '', class: "glyphicon glyphicon-#{icon_name}")
			end

		end
	end	
end
