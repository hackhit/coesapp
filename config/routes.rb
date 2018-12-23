Rails.application.routes.draw do

  resources :secciones
  resources :asignaturas
  resources :catedras
  resources :tipo_estado_calificaciones
  resources :tipo_estado_inscripciones
  resources :departamentos
  resources :usuarios
scope module: :admin do
  resources :periodos
  resources :planes
end
  root to: 'visitors#index'
end
