Rails.application.routes.draw do
  
  resources :tipoasignaturas

  resources :visitors, only: [:index] do
    collection do
      post :validar
      get 'olvido_clave'
      get 'un_rol'
      get 'seleccionar_rol'
      get 'cerrar_sesion'
    end
  end


  scope module: :admin do

    resources :escuelas
    resources :carteleras do
      member do
        get 'set_activa'
      end
    end
    resources :descargar do
      member do
        get :kardex
        get 'acta_examen_excel'
        get 'acta_examen'
        get 'constancia_inscripcion'
        get 'constancia_estudio'

      end
    end
    # get '/descargar/acta_examen_excel'
    # get '/descargar/kardex'
    # get '/descargar/acta_examen'
    # get '/descargar/constancia_inscripcion'

    get '/principal_admin/index'
    get '/principal_admin/set_tab'
    get '/principal_admin/ver_seccion_admin'
    get '/principal_admin/detalle_usuario'

    resources :inscripcionsecciones do
      collection do 
        get 'buscar_estudiante'
        get :seleccionar
        post :inscribir
        post :crear
      end
      member do 
        get :seleccionar
        get :resumen
        get 'set_retirar'
      end
    end
    get '/principal_profesor/index'
    get '/principal_estudiante/index'

    post '/calificar/calificar'
    get '/calificar/seleccionar_seccion'
    get '/calificar/ver_seccion'
    get '/calificar/descargar_notas'

    # get '/historial_plan/index'
    # post '/historial_plan/create'
    # post '/historial_plan/update'

    resources :historialplanes

    resources :catedradepartamentos, only: [:create, :destroy]

    resources :secciones do
      collection do
        post 'cambiar_capacidad'
        post 'cambiar_profe_seccion'
        post 'agregar_profesor_secundario'
      end
      member do
        get 'desasignar_profesor_secundario'
        get 'seleccionar_profesor'
      end
    end

    resources :asignaturas do
      member do
        get 'set_activa'
      end
    end
    resources :catedras
    resources :tipo_estado_calificaciones
    resources :tipo_estado_inscripciones
    resources :departamentos
    resources :combinaciones
    resources :usuarios do
      collection do
        # post :index
        get :busquedas
      end
      member do
        post 'set_estudiante'
        post 'set_administrador'
        post 'set_profesor'
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