class Bitacora < ApplicationRecord
  # CONSTANTES
  GENERAL = 0
  SESSION = 1
  CREACION = 2
  ACTUALIZACION = 3
  ELIMINACION = 4
  DESCARGA = 5

  # VARIABLES
  enum tipo: [:general, :sesion, :creacion, :actualizacion, :eliminacion, :descarga]

  #TRIGGERS
  after_initialize :set_default_tipo, if: :new_record?

  # RELACIONES
  belongs_to :estudiante, primary_key: :usuario_id, optional: true
  belongs_to :profesor, primary_key: :usuario_id, optional: true
  belongs_to :administrador, primary_key: :usuario_id, optional: true
  belongs_to :usuario, primary_key: :ci, optional: true

  def self.info(params = {}) 
    predeterminados = {
      descripcion: nil,
      estudiante_id: nil,
      usuario_id: nil,
      administrador_id: nil,
      profesor_id: nil,
      ip_origen: nil
    }         
    params = predeterminados.merge params   
    Bitacora.create!(params)
  end

  protected

  def set_default_tipo
    tipo ||= :generales
  end

end
