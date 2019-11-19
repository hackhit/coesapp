module ApplicationHelper

	def row_filter objetos, tipo
		haml_tag :b, "#{tipo.titleize}:"
		capture_haml do
			select_tag tipo, options_for_select(objetos), {class: 'text-field form-control filtrables', multiple: true}
		end

	end

	def col_filter objetos
		haml_tag :b, "#{objetos.name.titleize}:"
		capture_haml do 
			collection_select(objetos.name.downcase, :id, objetos, :id, :descripcion_filtro, {}, {class: "text-field form-control #{objetos.name.downcase}Filtrables", multiple: true})
		end
	end

	def filtros_etiquetas objetos
		capture_haml do 
			
			haml_tag :p, "#{objetos.name.titleize}:"

			objetos.each do |e| 
				colocar_etiqueta e
			end
			haml_tag :hr
		end
	end

	def colocar_etiqueta objeto

		haml_tag :label, objeto.id, class: 'tooltip-btn btn btn-primary btn-sm filtrable ml-sm-1', 'data_toggle': :tooltip, title: objeto.descripcion_filtro, id: objeto.id, class_name: objeto.class.to_s

	end

	def agregar_onoffswitch titulo_tooltip, onChange, id, value = false
		# No funciona, no agrega el check_box
		content_tag :b, class: 'tooltip-btn', 'data_toggle'=> :tooltip, title: titulo_tooltip do
			content_tag :div, class: 'onoffswitch' do
				capture_haml do
					check_box nil, :activa, checked: value, class: 'onoffswitch-checkbox', id: "switch_#{id}", onChange: onChange
					content_tag :label, class: 'onoffswitch-label', for: "switch_#{id}" do

						haml_tag :span, class: 'onoffswitch-inner'
						haml_tag :span, class: 'onoffswitch-switch'

					end
				end
			end
		end
	end


	def add_card_header tipo, titulo
		capture_haml do
			haml_tag :div, class: 'card' do
				haml_tag :div, class: 'card-header', id: "heading_#{tipo}" do
					haml_tag :h5, class: 'mb-0' do
						link_to titulo, "#collapse_#{tipo}", {"aria-controls": "collapse_#{tipo}", "aria-expanded": :true, "data-target": "#collapse_#{tipo}", "data-toggle": :collapse, class: "btn btn-link"}
					end
				end
			end
		end		
	end

	def colocar_nav_tab name, objetos, contenido = nil, vertical = false
		# Este metodo no está completo
		# La inclusión del 'yield' en estos metodos puede ayudar a completarlo luego se llama el bloque con el 'content'

		# def content_box
		#   haml_tag :div, :class => "holder" do
		#     haml_tag :div, :class => "top"
		#     haml_tag :div, :class => "content" do
		#       yield
		#     haml_tag :div, :class => "bottom"
		#   end
		# end
		# and in haml

		# %html
		#   %head
		#   %body
		#     Maybee some content here.
		#     = content_box do
		#       Content that goes in the content_box like news or stuff


		if vertical
			verti = 'flex-column'
			orientacion = 'vertical'
			row = 'row'
			col2 = 'col-2'
			col10 = 'col-10'
		else
			verti = ''
			orientacion = ''
			row = ''
			col2 = ''
			col10 = ''			
		end

		content_tag :b do "Seleccione #{name.titleize}" end
		capture_haml do 
			haml_tag :div, class: row do
				haml_tag :div, class: col2 do
					haml_tag :ul, class: "nav nav-pills mb-3 #{verti}", role: :tablist, "aria-orientation": orientacion, id: "pills-#{name}-tab" do
						capture_haml do 
							objetos.each do |obj|
								haml_tag :li, class: 'nav-item' do
									activo = (session["#{name}_id"].eql? obj.id) ? "active" : ""
									link_to obj.contenido, "##{name}_#{obj.id}", "data-toggle": :tab, onclick: "alert('#{name}_id', '#{obj.id}');", class: "nav-link #{activo}"
									yield
								end
							end
						end
					end
				end
			end
		end
	end

	def badge_icon_tooltip url, classes, title_tooltip, icon1, icon2 = nil, title = nil

		if url.include? 'descargar'
			target = '_blank'
			icon2 = 'download-alt'
		else
			target = ''
		end

		link_to url, class: "tooltip-btn badge #{classes}", role: :button, 'data_toggle': :tooltip, title: title_tooltip, target: target do
			capture_haml{"#{glyph icon1} #{glyph icon2 if icon2} #{title}"}
		end

	end


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
		btn_toggle 'btn-success', 'education', href, title_tooltip, value
	end

	def btn_add_success href, title_tooltip, value
		btn_success 'plus', href, title_tooltip, value
	end


	def btn_atras href
		btn_toggle 'btn-outline-secondary', 'chevron-left', href, 'Regresar', 'Regresar'
	end

	def btn_edit_primary href, title_tooltip, value
		btn_toggle 'btn-outline-primary', 'edit', href, title_tooltip, value
	end

	def btn_success icon, href, title_tooltip, value
		btn_toggle 'btn-outline-success', icon, href, title_tooltip, value
	end

	def btn_toggle_download classes, href, title_tooltip, value, onclick_action=nil
		btn_toggle classes, 'download-alt', href, "Descargar #{title_tooltip}", value, onclick_action
	end

	def btn_toggle type, icon, href, title_tooltip, value, onclick_action=nil

		target = (href.include? 'descargar') ? '_blank' : ''
		link_to href, class: "btn btn-sm #{type} tooltip-btn", 'data_toggle': :tooltip,  title: title_tooltip, onclick: onclick_action, target: target do
			capture_haml{"#{glyph icon} #{value}"}
		end
	end

	def simple_icon_toggle_modal_edit title_tooltip, id_modal
		simple_icon_toggle_modal title_tooltip, '', 'edit', id_modal
	end

	def simple_icon_toggle_modal title_tooltip, color_type, icon, id_modal
		simple_toggle 'javascript:void(0)', '', title_tooltip, color_type, icon, "$('##{id_modal}').modal();"
	end

	def simple_toggle_rounded href, value, title_tooltip, color_type, icon, onclick_action = nil
		target = (href.include? 'descargar') ? '_blank' : ''
		content_tag :b, class: "tooltip-btn border p-1 border-#{color_type} rounded", 'data_toggle': :tooltip, title: title_tooltip do
			link_to href, class: "text-#{color_type}", onclick: onclick_action, target: target do
				capture_haml{"#{glyph icon} #{value}"}
			end
		end

	end

	def simple_tooltip_plan plan

		if plan
			id = plan.id
			desc = plan.descripcion_filtro
		else
			id = 'SP'
			desc = 'Sin plan asignado'
		end

		content_tag :b, class: "tooltip-btn", 'data_toggle': :tooltip, title: desc do
			capture_haml{id}
		end		
	end

	def simple_toggle href, value, title_tooltip, color_type, icon, onclick_action = nil
		target = (href.include? 'descargar') ? '_blank' : ''
		link_to href, class: "tooltip-btn text-#{color_type}", onclick: onclick_action, target: target, 'data_toggle': :tooltip, title: title_tooltip do
			capture_haml{"#{glyph icon} #{value}"}
		end

	end

	def btn_toggle_modal icon, title_tooltip, value, id_modal
		btn_toggle 'btn-outline-success', icon, 'javascript:void(0)', title_tooltip, value, "$('##{id_modal}').modal();"
	end

	def btn_plus_seccion_modal a
		onClick = "$('#newSeccion').modal();"
		onClick += "setAsignaturaToNewSeccion('#{a.id}', '#{a.descripcion}')" if a
		btn_toggle 'btn-outline-success', 'plus', 'javascript:void(0)', 'Agregar Sección', '', onClick
	end

end
