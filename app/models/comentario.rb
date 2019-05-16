class Comentario < ApplicationRecord


	scope :recientes, -> {where("updated_at >= ?", Date.today-1.week)}
	# scope :publicos, -> {where(publico: true)}
	# scope :privados, -> {where(publico: false)}

	enum estado: [:admins, :estudiantes, :profesores, :publicos]


end
