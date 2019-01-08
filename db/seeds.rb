# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Cartelera.create(contenido: 'Sistema de Control de Estudio By Lic. Daniel Moros', activa: true)
p "#{Cartelera.count} Cartelera Creada!"

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

Catedra.create([{id: 'IB', descripcion: 'Idioma Básico'}, {id: 'GE', descripcion: 'Gramática y Especialización'}, ])
p "#{Catedra.count} Catedra Creada!"

Departamento.create([{id: 'ALE', descripcion: 'Alemán'}, {id: 'ING', descripcion: 'Inglés'}, {id: 'ITA', descripcion: 'Italiano'}])
p "#{Departamento.count} Departamentos Creados!"

Usuario.create([{id: '1', password: '1', nombres: 'Fulanito', apellidos: 'De Tal', email: 'fulanodetal@email.com',telefono_habitacion: '02124321098', telefono_movil: '04188887766', sexo: 1},{id: '2', password: '2', nombres: 'Menganito', apellidos: 'De Cual', email: 'menganito@email.com',telefono_habitacion: '02124321097', telefono_movil: '04188887755'}])
p "#{Usuario.count} Usuarios Creados!"

Administrador.create!([{usuario_id: 1, rol: 0},{usuario_id: 2, rol: 1, departamento_id: 'ALE'}])
p "#{Administrador.count} Admin Creado!"

Profesor.create([{usuario_id: 1, departamento_id: 'ALE'}, {usuario_id: 2, departamento_id: 'ALE'}])
p "#{Profesor.count} Profesor Creado!"

Estudiante.create([{usuario_id: 2}])
p "#{Estudiante.count} Estudiante Creado!"

Catedradepartamento.create([{departamento_id: 'ALE', catedra_id: 'IB'}])
p "#{Catedradepartamento.count} CatedraDepartamento Creado!"

Asignatura.create([{id: 'ALEI', descripcion: 'Alemán I', anno: 1, departamento_id: 'ALE', catedra_id: 'IB', id_uxxi: '01010101', creditos: 6, tipo: :obligatoria, }, {id: 'ALEII', descripcion: 'Alemán II', anno: 2, departamento_id: 'ALE', catedra_id: 'IB', id_uxxi: '01010102', creditos: 5, tipo: :electiva}])
p "#{Asignatura.count} Asignaturas Creadas!"

Periodo.create([{id: '2018-02A', inicia: '2018-12-26', culmina: '2019-12-27'}, {id: '2017-02A', inicia: '2017-12-26', culmina: '2018-12-25'}])
p "#{Periodo.count} Periodos Creados!"

Plan.create([{id: 'G270', descripcion: 'Lic. Traducción e Interpretación'}, {id: 'G280', descripcion: 'Lic. Traducción'}, {id: 'G290', descripcion: 'Lic. Idiomas Modernos'}])
p "#{Plan.count} Planes Creados!"

Historialplan.create([{estudiante_id: 2, periodo_id: Periodo.first.id, plan_id: Plan.first.id}])
p "#{Historialplan.count} Historial de Plan Creado!"

Combinacion.create([{estudiante_id: 2, periodo_id: Periodo.first.id, idioma1_id: Departamento.first.id, idioma2_id: Departamento.last.id}])
p "#{Combinacion.count} Combinaciones de Idiomas Creado!"

Seccion.create([{numero: 'A1', asignatura_id: Asignatura.first.id, periodo_id: Periodo.last.id, profesor_id: Profesor.first.id}, {numero: 'A2', asignatura_id: Asignatura.first.id, periodo_id: Periodo.last.id, profesor_id: Profesor.first.id}])
p "#{Seccion.count} Sección Creada!"

Inscripcionseccion.create([{estudiante_id: Estudiante.first.id, seccion_id: Seccion.first.id}])
p "#{Inscripcionseccion.count} Inscripcion en Sección Creada!"

SeccionProfesorSecundario.create([{profesor_id: Profesor.last.id, seccion_id: Seccion.first.id}])
p "#{SeccionProfesorSecundario.count} profesor secundario asociado a sección!"