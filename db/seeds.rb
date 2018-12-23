# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

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
