# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Cartelera.create(contenido: 'Cartelera del Sistema de Control de Estudios de la Facultad de Humanidades y Educación', activa: true)
p "#{Cartelera.count} Cartelera Creada!"

TipoSeccion.create([{id: :NF, descripcion: 'Nota Final'}, {id: :NR, descripcion: 'Reparación'}, {id: :NS, descripcion: 'Suficiencia'}, {id: :EE, descripcion: 'Equivalencia Externa'}, {id: :EI, descripcion: 'Equivalencia Interna'}, {id: :ND, descripcion: 'Diferido'}])

Escuela.create([{id: 'ARTE', descripcion: 'ARTES'}, 
	{id: 'BIAR', descripcion: 'BIBLIOTECOLOGÍA Y ARCHIVOLOGÍA'}, 
	{id: 'COMU', descripcion: 'COMUNICACIÓN SOCIAL'}, 
	{id: 'EDUC', descripcion: 'EDUCACIÓN'},
	{id: 'FILO', descripcion: 'FILOSOFÍA'},
	{id: 'GEOG', descripcion: 'GEOGRAFÍA'},
	{id: 'HIST', descripcion: 'HISTORIA'},
	{id: 'IDIO', descripcion: 'IDIOMAS MODERNOS'},
	{id: 'LETR', descripcion: 'LETRAS'},
	{id: 'PSIC', descripcion: 'PSICOLOGÍA'} ])

Tipoasignatura.create([{id: :L, descripcion: :obtativa}, {id: :O, descripcion: :electiva}, {id: :B, descripcion: :obligatoria}, {id: :P, descripcion: :proyecto}])
p "#{Tipoasignatura.count} Tipo Asignaturas Creadas!"

ParametroGeneral.create([{id: 'PERIODO_ACTUAL_ID', valor: '2018-02A'}, {id: 'ACTIVAR_PROGRAMACIONES', valor: 'ENCENDIDAS'}])
p "#{ParametroGeneral.count} Parametro General Creado!"

TipoEstadoInscripcion.create([{
	id: 'CO', descripcion: 'Congelado' },
	{id: 'INS', descripcion: 'Inscripto' },
	{id: 'NUEVO', descripcion: 'Nuevo Ingreso' },
	{id: 'REINC', descripcion: 'Reincorporado' },
	{id: 'RET', descripcion: 'Retirado' },
	{id: 'VAL', descripcion: 'Válido para inscribir' }])
p "#{TipoEstadoInscripcion.count} TipoEstadoInscripciones Creadas!"

TipoEstadoCalificacion.create([{
	id: 'AP', descripcion: 'Aprobado' },
	{id: 'PI', descripcion: 'Perdida por Inasistencia' },
	{id: 'RE', descripcion: 'Reprobado' },
	{id: 'SC', descripcion: 'Sin Calificar' }])
p "#{TipoEstadoCalificacion.count} TipoEstadoCalificaciones Creadas!"

Usuario.create([{id: '10264009', password: '10264009', nombres: 'CARLOS A.', apellidos: 'SAAVEDRA A.', email: 'saavedraazuaje73@gmail.com',telefono_habitacion: '', telefono_movil: '04143661978', sexo: 1},{id: '15573230', password: '15573230', nombres: 'DANIEL JOSUÉ', apellidos: 'MOROS CASTILLO', email: 'moros.daniel@gmail.com',telefono_habitacion: '02124221011', telefono_movil: '04164126484'}])
p "#{Usuario.count} Usuarios Creados!"

Administrador.create!([{usuario_id: 10264009, rol: 0},{usuario_id: 15573230, rol: 0}])
p "#{Administrador.count} Admin Creado!"
