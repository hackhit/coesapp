Rails.application.routes.draw do
  
  post '/visitors/validar'
  get '/visitors/un_rol'
  get '/visitors/seleccionar_rol'
  get '/visitors/olvido_clave'
  get '/visitors/cerrar_sesion'


  scope module: :admin do
    get '/descargar/acta_examen_excel'
    get '/descargar/acta_examen'
    get '/descargar/constancia_inscripcion'

    get '/principal_admin/index'
    get '/principal_admin/set_tab'
    get '/principal_admin/ver_seccion_admin'
    get '/principal_admin/detalle_usuario'

    resources :inscripcionsecciones do
      collection do 
        get 'buscar_estudiante'
        get :seleccionar
        post :inscribir
      end
      member do 
        get :resumen
      end
    end
    get '/principal_profesor/index'
    get '/principal_estudiante/index'

    post '/calificar/calificar'

    # get '/historial_plan/index'
    # post '/historial_plan/create'
    # post '/historial_plan/update'

    resources :historialplanes

    resources :catedradepartamentos, only: [:create, :destroy]

    resources :secciones do
      collection do
        get 'seleccionar_profesor'
        post 'cambiar_capacidad'
        post 'cambiar_profe_seccion'
        post 'agregar_profesor_secundario'
        get 'desasignar_profesor_secundario'
      end
    end

    resources :asignaturas
    resources :catedras
    resources :tipo_estado_calificaciones
    resources :tipo_estado_inscripciones
    resources :departamentos
    resources :combinaciones
    resources :usuarios do
      member do
        post 'cambiar_ci'
        get 'resetear_contrasena'
      end
    end
    resources :periodos
    resources :planes
  end
  
  root to: 'visitors#index'
end



  # resources :wa_messages, only: [:index] do
  #   member do
  #     get 'set_unread'
  #   end
  #   collection do
  #     post 'receive'
  #     post 'send_message'
  #   end  
  # end