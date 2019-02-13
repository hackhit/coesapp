class Bitacora < ApplicationRecord
  # CONSTANTES
  GENERAL = 0
  CREACION = 1
  ACTUALIZACION = 2
  ELIMINACION = 3
  DESCARGA = 4
  ESPECIAL = 5

  # VARIABLES
  enum tipo: [:general, :creacion, :actualizacion, :eliminacion, :descarga, :especial]

  #TRIGGERS
  before_create :set_default_tipo, if: :new_record?

  # RELACIONES
  belongs_to :usuario, primary_key: :ci, optional: true

  protected

  def set_default_tipo
    tipo ||= :generales
  end

end
