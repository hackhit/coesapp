Rails.application.routes.draw do
  
  post '/visitors/validar'
  get '/visitors/un_rol'
  get '/visitors/seleccionar_rol'
  get '/visitors/olvido_clave'
  get '/visitors/cerrar_sesion'

  resources :catedras_departamentos
  scope module: :admin do
    resources :secciones
    resources :asignaturas
    resources :catedras
    resources :tipo_estado_calificaciones
    resources :tipo_estado_inscripciones
    resources :departamentos
    resources :usuarios
    resources :periodos
    resources :planes
  end
  root to: 'visitors#index'
end
