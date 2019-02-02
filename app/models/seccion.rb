class Seccion < ApplicationRecord

	# ASOCIACIONES:
	belongs_to :asignatura
	belongs_to :periodo
	belongs_to :tipo_seccion
	belongs_to :profesor, optional: true 
	has_one :escuela, through: :asignatura

	has_many :inscripcionsecciones, dependent: :delete_all
	accepts_nested_attributes_for :inscripcionsecciones
	has_many :estudiantes, through: :inscripcionsecciones, source: :estudiante

	has_many :secciones_profesores_secundarios,
		:class_name => 'SeccionProfesorSecundario'
	accepts_nested_attributes_for :secciones_profesores_secundarios
	has_many :profesores, through: :secciones_profesores_secundarios, source: :profesor

    # VALIDACIONES:
    validates :asignatura_id, presence: true
    # validates :profesor_id, presence: true, if: :new_record?
    validates :periodo_id, presence: true
    validates :numero, presence: true
	validates_uniqueness_of :numero, scope: [:periodo_id, :asignatura_id], message: 'La sección ya existe, inténtalo de nuevo!', field_name: false

    # SCOPES:
	scope :calificadas, -> {where "calificada IS TRUE"}
	scope :sin_calificar, -> {where "calificada IS FALSE"}
	scope :del_periodo, lambda { |periodo_id| where "periodo_id = ?", periodo_id}
	# scope :del_periodo_actual, -> { where "periodo_id = ?", ParametroGeneral.periodo_actual_id}


	# FUNCIONES:

	def capacidad_vs_inscritos
		"#{self.capacidad} / #{total_estudiantes}"
	end

	def calificada_valor
		self.calificada ? 'Sí' : 'No'
	end

	def self.ttl

a = {"709109110" => "ALEMI",
"709109111" => "ALEMII",
"709109112" => "ALEMIII",
"709109118" => "ALEMIV",
"709109119" => "ALEMV",
"700110001" => "AVAING",
"700110002" => "CIVFRACA",
"709309313" => "CONALE",
"709309323" => "CONFRA",
"709309333" => "CONING",
"709309343" => "CONITA",
"709309353" => "CONPOR",
"709119052" => "CONTUSLI",
"709109115" => "CTTIALEM",
"709109125" => "CTTIFRAN",
"709209116" => "CTTIIALEM",
"709209126" => "CTTIIFRAN",
"709209117" => "CTTIIIALEM",
"709209127" => "CTTIIIFRAN",
"709209137" => "CTTIIIING",
"709209147" => "CTTIIIITA",
"709209136" => "CTTIIING",
"709109157" => "CTTIIIPOR",
"709209146" => "CTTIIITA",
"709109135" => "CTTIING",
"709209156" => "CTTIIPOR",
"709109145" => "CTTIITA",
"709109155" => "CTTIPOR",
"709119956" => "DIDACEXT",
"709109274" => "ECO",
"709409012" => "ESTALE",
"709119208" => "ESTDISC",
"709409022" => "ESTFRA",
"709409032" => "ESTING",
"709409042" => "ESTITA",
"709409052" => "ESTPOR",
"709209011" => "FFALEM",
"709209021" => "FFFRAN",
"709209031" => "FFING",
"709209041" => "FFITA",
"709209051" => "FFPOR",
"709109120" => "FRANI",
"709109121" => "FRANII",
"709109122" => "FRANIII",
"709209128" => "FRANIV",
"709209129" => "FRANV",
"709119967" => "GRIEGO",
"709119207" => "HERME",
"709109130" => "INGI",
"709109131" => "INGII",
"709109132" => "INGIII",
"709209138" => "INGIV",
"709209139" => "INGV",
"709119476" => "INIARA",
"709109272" => "ININTER",
"709109271" => "INITRA",
"709119088" => "INTESPE",
"709119108" => "INTROLITE",
"709109140" => "ITAI",
"709109141" => "ITAII",
"709109142" => "ITAIII",
"709209148" => "ITAIV",
"709209149" => "ITAV",
"709119003" => "JAP",
"709109072" => "LEI",
"709109073" => "LEII",
"709109070" => "LINGUI",
"709109071" => "LINGUII",
"709109270" => "METO",
"709209010" => "MORALEM",
"709119007" => "MORFOESPEL",
"709209020" => "MORFRAN",
"709209030" => "MORING", 
"709209040" => "MORITA",
"709209050" => "MORPOR",
"709109273" => "POLI",
"709109150" => "PORI",
"709109151" => "PORII",
"709109152" => "PORIII",
"709209158" => "PORIV",
"709209159" => "PORV",
"709109279" => "SEMI",
"709109966" => "SERCOM",
"709309314" => "SIMALEI",
"709309315" => "SIMALEII",
"709309324" => "SIMFRAI",
"709309325" => "SIMFRAII",
"709309334" => "SIMINGI",
"709309335" => "SIMINGII",
"709309344" => "SIMITAI",
"709309345" => "SIMITAII",
"709309354" => "SIMPORI",
"709309355" => "SIMPORII",
"709409074" => "TERMIN",
"709309310" => "TRAALEI",
"709309311" => "TRAALEII",
"709119953" => "TRADAUD",
"700110000" => "TRADFRAN",
"709119102" => "TRADING",
"709409312" => "TRAESPALE",
"709409322" => "TRAESPFRA",
"709409332" => "TRAESPING",
"709409342" => "TRAESPITA",
"709409352" => "TRAESPPOR",
"709309320" => "TRAFRAI",
"709309321" => "TRAFRAII",
"709309330" => "TRAINGI",
"709309331" => "TRAINGII",
"709309340" => "TRAITAI",
"709309341" => "TRAITAII",
"709309350" => "TRAPORI",
"709309351" => "TRAPORII",
"700110003" => "WEB2"}
		total = 0
 		a.each_pair do |x,y|
 			secciones = Seccion.where(asignatura_id: y).each do |s| 
 				p s.descripcion
 				total += 1 if s.update(asignatura_id: x)
 			end
 		end
 		p "*".center(300, "*")
 		p " #{total} ".center(300, "*")
 		p "*".center(300, "*")
		
	end



	def total_estudiantes
		inscripcionsecciones.count
	end

	def total_confirmados
		inscripcionsecciones.confirmados.count
	end

	def total_aprobados
		inscripcionsecciones.aprobados.count
	end

	def total_reprobados
		inscripcionsecciones.reprobados.count
	end

	def total_perdidos
		inscripcionsecciones.perdidos.count
	end

	def total_sin_calificar
		inscripcionsecciones.sin_calificar.count
	end

	def descripcion
		descripcion = ""
		descripcion += asignatura.descripcion if asignatura
		
		if numero
			if self.suficiencia?
				descripcion += " (Suficiencia)"
			elsif self.reparacion?
				descripcion += " (Reparación)"
			else
				descripcion += " - #{numero}"
			end
		end 
		return descripcion
	end

	def descripcion_profesor_asignado
		if profesor
			profesor.descripcion_usuario
		else
			"No asignado"
		end
	end

	def ejercicio
		"#{periodo_id}"
	end

	def r_or_f?
		if numero.include? 'R'
			return 'R'
		else 
			'F'
		end
	end

	def reparacion?
		return numero.include? 'R'
	end


	def suficiencia?
		return numero.include? 'S'
	end

	def tipo_convocatoria
		aux = numero[0..1]
		if reparacion?
			aux = "RA2" #{aux}"
		else
			aux = "FA2" #"F#{aux}"
		end
		return aux
	end

	def acta_no
		"#{self.seccion.asignatura.id_uxxi}#{self.seccion.numero}#{self.periodo_id}"
	end

	# FUNCIONES PROTEGIDAS

end
