
class ImportCsv

	# def self.preview url
		
	# 	require 'csv'    

	# 	csv_text = File.read(url)
		
	# 	return CSV.parse(csv_text, headers: true)
	# end

	def self.get_section_id periodo_id, numero, asignatura_id

		a = { "ALEMI" => "709109110", 
			"ALEMII" => "709109111", 
			"ALEMIII" => "709109112", 
			"ALEMIV" => "709109118", 
			"ALEMV" => "709109119", 
			"AVAING" => "700110001", 
			"CIVFRACA" => "700110002", 
			"CONALE" => "709309313", 
			"CONFRA" => "709309323", 
			"CONING" => "709309333", 
			"CONITA" => "709309343", 
			"CONPOR" => "709309353", 
			"CONTUSLI" => "709119052", 
			"CTTIALEM" => "709109115", 
			"CTTIFRAN" => "709109125", 
			"CTTIIALEM" => "709209116", 
			"CTTIIFRAN" => "709209126", 
			"CTTIIIALEM" => "709209117", 
			"CTTIIIFRAN" => "709209127", 
			"CTTIIIING" => "709209137", 
			"CTTIIIITA" => "709209147", 
			"CTTIIING" => "709209136", 
			"CTTIIIPOR" => "709109157", 
			"CTTIIITA" => "709209146", 
			"CTTIING" => "709109135", 
			"CTTIIPOR" => "709209156", 
			"CTTIITA" => "709109145", 
			"CTTIPOR" => "709109155", 
			"DIDACEXT" => "709119956", 
			"ECO" => "709109274", 
			"ESTALE" => "709409012", 
			"ESTDISC" => "709119208", 
			"ESTFRA" => "709409022", 
			"ESTING" => "709409032", 
			"ESTITA" => "709409042", 
			"ESTPOR" => "709409052", 
			"FFALEM" => "709209011", 
			"FFFRAN" => "709209021", 
			"FFING" => "709209031", 
			"FFITA" => "709209041", 
			"FFPOR" => "709209051", 
			"FRANI" => "709109120", 
			"FRANII" => "709109121", 
			"FRANIII" => "709109122", 
			"FRANIV" => "709209128", 
			"FRANV" => "709209129", 
			"GRIEGO" => "709119967", 
			"HERME" => "709119207", 
			"INGI" => "709109130", 
			"INGII" => "709109131", 
			"INGIII" => "709109132", 
			"INGIV" => "709209138", 
			"INGV" => "709209139", 
			"INIARA" => "709119476", 
			"ININTER" => "709109272", 
			"INITRA" => "709109271", 
			"INTESPE" => "709119088", 
			"INTROLITE" => "709119108", 
			"ITAI" => "709109140", 
			"ITAII" => "709109141", 
			"ITAIII" => "709109142", 
			"ITAIV" => "709209148", 
			"ITAV" => "709209149", 
			"JAP" => "709119003", 
			"LEI" => "709109072", 
			"LEII" => "709109073", 
			"LINGUI" => "709109070", 
			"LINGUII" => "709109071", 
			"METO" => "709109270", 
			"MORALEM" => "709209010", 
			"MORFOESPEL" => "709119007", 
			"MORFRAN" => "709209020", 
			"MORING" => "709209030", 
			"MORITA" => "709209040", 
			"MORPOR" => "709209050", 
			"POLI" => "709109273", 
			"PORI" => "709109150", 
			"PORII" => "709109151", 
			"PORIII" => "709109152", 
			"PORIV" => "709209158", 
			"PORV" => "709209159", 
			"SEMI" => "709109279", 
			"SERCOM" => "709109966", 
			"SIMALEI" => "709309314", 
			"SIMALEII" => "709309315", 
			"SIMFRAI" => "709309324", 
			"SIMFRAII" => "709309325", 
			"SIMINGI" => "709309334", 
			"SIMINGII" => "709309335", 
			"SIMITAI" => "709309344", 
			"SIMITAII" => "709309345", 
			"SIMPORI" => "709309354", 
			"SIMPORII" => "709309355", 
			"TERMIN" => "709409074", 
			"TRAALEI" => "709309310", 
			"TRAALEII" => "709309311", 
			"TRADAUD" => "709119953", 
			"TRADFRAN" => "700110000", 
			"TRADING" => "709119102", 
			"TRAESPALE" => "709409312", 
			"TRAESPFRA" => "709409322", 
			"TRAESPING" => "709409332", 
			"TRAESPITA" => "709409342", 
			"TRAESPPOR" => "709409352", 
			"TRAFRAI" => "709309320", 
			"TRAFRAII" => "709309321", 
			"TRAINGI" => "709309330", 
			"TRAINGII" => "709309331", 
			"TRAITAI" => "709309340", 
			"TRAITAII" => "709309341", 
			"TRAPORI" => "709309350", 
			"TRAPORII" => "709309351", 
			"WEB2" => "700110003"}


		
	end

	def self.resumen inscritos, existentes, no_inscritos, nuevas_secciones, secciones_no_creadas, estudiantes_inexistentes, asignaturas_inexistentes
		"</br><b>Resumen:</b> 
			</br></br>Total Nuevos Inscritos: <b>#{inscritos}</b>
			</br>Total Existentes: <b>#{existentes}</b>
			</br>Total Nuevas Secciones: <b>#{nuevas_secciones}</b>
			<hr></hr>Total Secciones No Creadas: <b>#{secciones_no_creadas.count}</b>
			</br><i>Detalle:</i></br>#{secciones_no_creadas.to_sentence} 
			<hr></hr>Total Asignaturas Inexistentes: <b>#{asignaturas_inexistentes.uniq.count}</b>
			</br><i>Detalle:</i></br> #{asignaturas_inexistentes.uniq.to_sentence}
			<hr></hr>Total Estudiantes Inexistentes: <b>#{estudiantes_inexistentes.uniq.count}</b>
			</br><i>Detalle:</i></br> #{estudiantes_inexistentes.uniq.to_sentence}"
	end

	def self.importar_secciones file, periodo_id
		require 'csv'

		csv_text = File.read(file)
		total_inscritos = 0
		total_existentes = 0
		estudiantes_no_inscritos = []
		total_nuevas_secciones = 0
		secciones_no_creadas = []
		estudiantes_inexistentes = []
		asignaturas_inexistentes = []

		self.resumen total_inscritos, total_existentes, estudiantes_no_inscritos, total_nuevas_secciones, secciones_no_creadas, estudiantes_inexistentes, asignaturas_inexistentes

		csv = CSV.parse(csv_text, headers: true)
			csv.each do |row|
				begin
					if a = Asignatura.where(id_uxxi: row.field(1)).limit(1).first
						
						unless s = Seccion.where(numero: row.field(2), periodo_id: periodo_id, asignatura_id: a.id).limit(1).first
						
							total_nuevas_secciones += 1 if s = Seccion.create!(numero: row.field(2), periodo_id: periodo_id, asignatura_id: a.id, tipo_seccion_id: 'NF')
						end

						if s
							if Estudiante.where(usuario_id: row.field(0)).count <= 0

								estudiantes_inexistentes << row.field(0)

							elsif s.inscripcionsecciones.where(estudiante_id: row.field(0)).count <= 0
								if s.inscripcionsecciones.create!(estudiante_id: row.field(0))
									total_inscritos += 1
								else
									estudiantes_no_inscritos << row.field(0)
								end
							else
								total_existentes += 1
							end

						else
							secciones_no_creadas << row.to_hash
						end
					else
						asignaturas_inexistentes << row.field(1)
					end
				rescue Exception => e
					return "Error excepcional: #{e.to_sentence}. #{self.resumen total_inscritos, total_existentes, estudiantes_no_inscritos, total_nuevas_secciones, secciones_no_creadas, estudiantes_inexistentes, asignaturas_inexistentes}"
				end
			end
		return "Proceso de importación completado con éxito. #{self.resumen total_inscritos, total_existentes, estudiantes_no_inscritos, total_nuevas_secciones, secciones_no_creadas, estudiantes_inexistentes, asignaturas_inexistentes}"

	end

	def self.importar_de_archivo url, objecto
		
		require 'csv'

		csv_text = File.read(url)
		total = 0
		# csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|
		csv = CSV.parse(csv_text, headers: true)
			csv.each do |row|
				if objecto.camelize.constantize.create!(row.to_hash)
				 	total += 1
				end
			end
		return total

	end


	def self.importar_de_archivo_secciones url, objecto
		
		require 'csv'

		a = { "ALEMI" => "709109110", 
"ALEMII" => "709109111", 
"ALEMIII" => "709109112", 
"ALEMIV" => "709109118", 
"ALEMV" => "709109119", 
"AVAING" => "700110001", 
"CIVFRACA" => "700110002", 
"CONALE" => "709309313", 
"CONFRA" => "709309323", 
"CONING" => "709309333", 
"CONITA" => "709309343", 
"CONPOR" => "709309353", 
"CONTUSLI" => "709119052", 
"CTTIALEM" => "709109115", 
"CTTIFRAN" => "709109125", 
"CTTIIALEM" => "709209116", 
"CTTIIFRAN" => "709209126", 
"CTTIIIALEM" => "709209117", 
"CTTIIIFRAN" => "709209127", 
"CTTIIIING" => "709209137", 
"CTTIIIITA" => "709209147", 
"CTTIIING" => "709209136", 
"CTTIIIPOR" => "709109157", 
"CTTIIITA" => "709209146", 
"CTTIING" => "709109135", 
"CTTIIPOR" => "709209156", 
"CTTIITA" => "709109145", 
"CTTIPOR" => "709109155", 
"DIDACEXT" => "709119956", 
"ECO" => "709109274", 
"ESTALE" => "709409012", 
"ESTDISC" => "709119208", 
"ESTFRA" => "709409022", 
"ESTING" => "709409032", 
"ESTITA" => "709409042", 
"ESTPOR" => "709409052", 
"FFALEM" => "709209011", 
"FFFRAN" => "709209021", 
"FFING" => "709209031", 
"FFITA" => "709209041", 
"FFPOR" => "709209051", 
"FRANI" => "709109120", 
"FRANII" => "709109121", 
"FRANIII" => "709109122", 
"FRANIV" => "709209128", 
"FRANV" => "709209129", 
"GRIEGO" => "709119967", 
"HERME" => "709119207", 
"INGI" => "709109130", 
"INGII" => "709109131", 
"INGIII" => "709109132", 
"INGIV" => "709209138", 
"INGV" => "709209139", 
"INIARA" => "709119476", 
"ININTER" => "709109272", 
"INITRA" => "709109271", 
"INTESPE" => "709119088", 
"INTROLITE" => "709119108", 
"ITAI" => "709109140", 
"ITAII" => "709109141", 
"ITAIII" => "709109142", 
"ITAIV" => "709209148", 
"ITAV" => "709209149", 
"JAP" => "709119003", 
"LEI" => "709109072", 
"LEII" => "709109073", 
"LINGUI" => "709109070", 
"LINGUII" => "709109071", 
"METO" => "709109270", 
"MORALEM" => "709209010", 
"MORFOESPEL" => "709119007", 
"MORFRAN" => "709209020", 
"MORING" => "709209030", 
"MORITA" => "709209040", 
"MORPOR" => "709209050", 
"POLI" => "709109273", 
"PORI" => "709109150", 
"PORII" => "709109151", 
"PORIII" => "709109152", 
"PORIV" => "709209158", 
"PORV" => "709209159", 
"SEMI" => "709109279", 
"SERCOM" => "709109966", 
"SIMALEI" => "709309314", 
"SIMALEII" => "709309315", 
"SIMFRAI" => "709309324", 
"SIMFRAII" => "709309325", 
"SIMINGI" => "709309334", 
"SIMINGII" => "709309335", 
"SIMITAI" => "709309344", 
"SIMITAII" => "709309345", 
"SIMPORI" => "709309354", 
"SIMPORII" => "709309355", 
"TERMIN" => "709409074", 
"TRAALEI" => "709309310", 
"TRAALEII" => "709309311", 
"TRADAUD" => "709119953", 
"TRADFRAN" => "700110000", 
"TRADING" => "709119102", 
"TRAESPALE" => "709409312", 
"TRAESPFRA" => "709409322", 
"TRAESPING" => "709409332", 
"TRAESPITA" => "709409342", 
"TRAESPPOR" => "709409352", 
"TRAFRAI" => "709309320", 
"TRAFRAII" => "709309321", 
"TRAINGI" => "709309330", 
"TRAINGII" => "709309331", 
"TRAITAI" => "709309340", 
"TRAITAII" => "709309341", 
"TRAPORI" => "709309350", 
"TRAPORII" => "709309351", 
"WEB2" => "700110003"}



		csv_text = File.read(url)
		total = 0
		# csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|
		csv = CSV.parse(csv_text, headers: true)
			csv.each do |row|

				nuevo_id_asignatura = a[row.field(2)]
				row["asignatura_id"] = nuevo_id_asignatura
				if objecto.camelize.constantize.create!(row.to_hash)
				 	total += 1
				end
			end
		return total

	end





	def self.importar_de_archivo_inscripcionsecciones url, objecto
		
		require 'csv'


		a = { "ALEMI" => "709109110", 
"ALEMII" => "709109111", 
"ALEMIII" => "709109112", 
"ALEMIV" => "709109118", 
"ALEMV" => "709109119", 
"AVAING" => "700110001", 
"CIVFRACA" => "700110002", 
"CONALE" => "709309313", 
"CONFRA" => "709309323", 
"CONING" => "709309333", 
"CONITA" => "709309343", 
"CONPOR" => "709309353", 
"CONTUSLI" => "709119052", 
"CTTIALEM" => "709109115", 
"CTTIFRAN" => "709109125", 
"CTTIIALEM" => "709209116", 
"CTTIIFRAN" => "709209126", 
"CTTIIIALEM" => "709209117", 
"CTTIIIFRAN" => "709209127", 
"CTTIIIING" => "709209137", 
"CTTIIIITA" => "709209147", 
"CTTIIING" => "709209136", 
"CTTIIIPOR" => "709109157", 
"CTTIIITA" => "709209146", 
"CTTIING" => "709109135", 
"CTTIIPOR" => "709209156", 
"CTTIITA" => "709109145", 
"CTTIPOR" => "709109155", 
"DIDACEXT" => "709119956", 
"ECO" => "709109274", 
"ESTALE" => "709409012", 
"ESTDISC" => "709119208", 
"ESTFRA" => "709409022", 
"ESTING" => "709409032", 
"ESTITA" => "709409042", 
"ESTPOR" => "709409052", 
"FFALEM" => "709209011", 
"FFFRAN" => "709209021", 
"FFING" => "709209031", 
"FFITA" => "709209041", 
"FFPOR" => "709209051", 
"FRANI" => "709109120", 
"FRANII" => "709109121", 
"FRANIII" => "709109122", 
"FRANIV" => "709209128", 
"FRANV" => "709209129", 
"GRIEGO" => "709119967", 
"HERME" => "709119207", 
"INGI" => "709109130", 
"INGII" => "709109131", 
"INGIII" => "709109132", 
"INGIV" => "709209138", 
"INGV" => "709209139", 
"INIARA" => "709119476", 
"ININTER" => "709109272", 
"INITRA" => "709109271", 
"INTESPE" => "709119088", 
"INTROLITE" => "709119108", 
"ITAI" => "709109140", 
"ITAII" => "709109141", 
"ITAIII" => "709109142", 
"ITAIV" => "709209148", 
"ITAV" => "709209149", 
"JAP" => "709119003", 
"LEI" => "709109072", 
"LEII" => "709109073", 
"LINGUI" => "709109070", 
"LINGUII" => "709109071", 
"METO" => "709109270", 
"MORALEM" => "709209010", 
"MORFOESPEL" => "709119007", 
"MORFRAN" => "709209020", 
"MORING" => "709209030", 
"MORITA" => "709209040", 
"MORPOR" => "709209050", 
"POLI" => "709109273", 
"PORI" => "709109150", 
"PORII" => "709109151", 
"PORIII" => "709109152", 
"PORIV" => "709209158", 
"PORV" => "709209159", 
"SEMI" => "709109279", 
"SERCOM" => "709109966", 
"SIMALEI" => "709309314", 
"SIMALEII" => "709309315", 
"SIMFRAI" => "709309324", 
"SIMFRAII" => "709309325", 
"SIMINGI" => "709309334", 
"SIMINGII" => "709309335", 
"SIMITAI" => "709309344", 
"SIMITAII" => "709309345", 
"SIMPORI" => "709309354", 
"SIMPORII" => "709309355", 
"TERMIN" => "709409074", 
"TRAALEI" => "709309310", 
"TRAALEII" => "709309311", 
"TRADAUD" => "709119953", 
"TRADFRAN" => "700110000", 
"TRADING" => "709119102", 
"TRAESPALE" => "709409312", 
"TRAESPFRA" => "709409322", 
"TRAESPING" => "709409332", 
"TRAESPITA" => "709409342", 
"TRAESPPOR" => "709409352", 
"TRAFRAI" => "709309320", 
"TRAFRAII" => "709309321", 
"TRAINGI" => "709309330", 
"TRAINGII" => "709309331", 
"TRAITAI" => "709309340", 
"TRAITAII" => "709309341", 
"TRAPORI" => "709309350", 
"TRAPORII" => "709309351", 
"WEB2" => "700110003"}



		csv_text = File.read(url)
		total = 0
		# csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|
		csv = CSV.parse(csv_text, headers: true)
			csv.each do |row|

				case row["tipo_estado_calificacion_id"]
				when 'RE'
					row["tipo_estado_calificacion_id"] = 'AP'
				when 'AP'
					row["tipo_estado_calificacion_id"] = 'A'
				end

				nuevo_id_asignatura = a[row.field(3)]
				
				s = Seccion.all.where(numero: row.field(1), periodo_id: row.field(2), asignatura_id: nuevo_id_asignatura).first 
				row.delete(1)
				row.delete(1)
				row.delete(1)
				row << {seccion_id: s.id}
				p "Seccion ID: #{s.id} #{row.to_hash} #{row.field('')}"

				if objecto.camelize.constantize.create!(row.to_hash)
				 	total += 1
				end
			end
		return total

	end

	def self.importar_de_archivo_profesor_secundario url, objecto
		
		require 'csv'

		a = { "ALEMI" => "709109110", 
			"ALEMII" => "709109111", 
			"ALEMIII" => "709109112", 
			"ALEMIV" => "709109118", 
			"ALEMV" => "709109119", 
			"AVAING" => "700110001", 
			"CIVFRACA" => "700110002", 
			"CONALE" => "709309313", 
			"CONFRA" => "709309323", 
			"CONING" => "709309333", 
			"CONITA" => "709309343", 
			"CONPOR" => "709309353", 
			"CONTUSLI" => "709119052", 
			"CTTIALEM" => "709109115", 
			"CTTIFRAN" => "709109125", 
			"CTTIIALEM" => "709209116", 
			"CTTIIFRAN" => "709209126", 
			"CTTIIIALEM" => "709209117", 
			"CTTIIIFRAN" => "709209127", 
			"CTTIIIING" => "709209137", 
			"CTTIIIITA" => "709209147", 
			"CTTIIING" => "709209136", 
			"CTTIIIPOR" => "709109157", 
			"CTTIIITA" => "709209146", 
			"CTTIING" => "709109135", 
			"CTTIIPOR" => "709209156", 
			"CTTIITA" => "709109145", 
			"CTTIPOR" => "709109155", 
			"DIDACEXT" => "709119956", 
			"ECO" => "709109274", 
			"ESTALE" => "709409012", 
			"ESTDISC" => "709119208", 
			"ESTFRA" => "709409022", 
			"ESTING" => "709409032", 
			"ESTITA" => "709409042", 
			"ESTPOR" => "709409052", 
			"FFALEM" => "709209011", 
			"FFFRAN" => "709209021", 
			"FFING" => "709209031", 
			"FFITA" => "709209041", 
			"FFPOR" => "709209051", 
			"FRANI" => "709109120", 
			"FRANII" => "709109121", 
			"FRANIII" => "709109122", 
			"FRANIV" => "709209128", 
			"FRANV" => "709209129", 
			"GRIEGO" => "709119967", 
			"HERME" => "709119207", 
			"INGI" => "709109130", 
			"INGII" => "709109131", 
			"INGIII" => "709109132", 
			"INGIV" => "709209138", 
			"INGV" => "709209139", 
			"INIARA" => "709119476", 
			"ININTER" => "709109272", 
			"INITRA" => "709109271", 
			"INTESPE" => "709119088", 
			"INTROLITE" => "709119108", 
			"ITAI" => "709109140", 
			"ITAII" => "709109141", 
			"ITAIII" => "709109142", 
			"ITAIV" => "709209148", 
			"ITAV" => "709209149", 
			"JAP" => "709119003", 
			"LEI" => "709109072", 
			"LEII" => "709109073", 
			"LINGUI" => "709109070", 
			"LINGUII" => "709109071", 
			"METO" => "709109270", 
			"MORALEM" => "709209010", 
			"MORFOESPEL" => "709119007", 
			"MORFRAN" => "709209020", 
			"MORING" => "709209030", 
			"MORITA" => "709209040", 
			"MORPOR" => "709209050", 
			"POLI" => "709109273", 
			"PORI" => "709109150", 
			"PORII" => "709109151", 
			"PORIII" => "709109152", 
			"PORIV" => "709209158", 
			"PORV" => "709209159", 
			"SEMI" => "709109279", 
			"SERCOM" => "709109966", 
			"SIMALEI" => "709309314", 
			"SIMALEII" => "709309315", 
			"SIMFRAI" => "709309324", 
			"SIMFRAII" => "709309325", 
			"SIMINGI" => "709309334", 
			"SIMINGII" => "709309335", 
			"SIMITAI" => "709309344", 
			"SIMITAII" => "709309345", 
			"SIMPORI" => "709309354", 
			"SIMPORII" => "709309355", 
			"TERMIN" => "709409074", 
			"TRAALEI" => "709309310", 
			"TRAALEII" => "709309311", 
			"TRADAUD" => "709119953", 
			"TRADFRAN" => "700110000", 
			"TRADING" => "709119102", 
			"TRAESPALE" => "709409312", 
			"TRAESPFRA" => "709409322", 
			"TRAESPING" => "709409332", 
			"TRAESPITA" => "709409342", 
			"TRAESPPOR" => "709409352", 
			"TRAFRAI" => "709309320", 
			"TRAFRAII" => "709309321", 
			"TRAINGI" => "709309330", 
			"TRAINGII" => "709309331", 
			"TRAITAI" => "709309340", 
			"TRAITAII" => "709309341", 
			"TRAPORI" => "709309350", 
			"TRAPORII" => "709309351", 
			"WEB2" => "700110003"}


		csv_text = File.read(url)
		total = 0
		# csv_data =CSV.generate(headers: true, col_sep: ";") do |csv|
		csv = CSV.parse(csv_text, headers: true)
			csv.each do |row|

				nuevo_id_asignatura = a[row.field(1)]
				
				s = Seccion.all.where(numero: row.field(2), periodo_id: row.field(0), asignatura_id: nuevo_id_asignatura).first 
				row.delete(0)
				row.delete(0)
				row.delete(0)
				row << {seccion_id: s.id}

				if objecto.camelize.constantize.create!(row.to_hash)
				 	total += 1
				end
			end
		return total

	end

end