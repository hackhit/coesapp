Rails.application.routes.draw do
  

  get 'hello_world', to: 'hello_world#index'
  resources :visitors, only: [:index] do
    collection do
      post :validar
      get 'olvido_clave'
      get 'un_rol'
      get 'seleccionar_rol'
      get 'cerrar_sesion'
      post 'olvido_clave_guardar'
    end
    member do
    end
  end

  scope module: :admin do

    resources :administradores, only: :index

    get '/importador/seleccionar_archivo'
    post '/importador/vista_previa'
    post '/importador/importar'

    resources :principal_admin, only: :index do
      collection do
        get 'set_tab'
        post 'cambiar_sesion_periodo'
      end
      member do 
        get 'ver_seccion_admin'
      end
    end

    resources :principal_profesor, only: :index 
    resources :principal_estudiante, only: :index do
      post 'actualizar_idiomas'
    end

    resources :tipo_secciones, :tipoasignaturas, :tipo_estado_calificaciones, :tipo_estado_inscripciones

    resources :periodos, :planes, :escuelas, :departamentos, :catedras
    
    resources :inscripcionperiodos, :historialplanes

    resources :catedradepartamentos, only: [:create, :destroy]

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
        get 'listado_seccion'
        get 'notas_seccion'
      end
    end

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

    resources :secciones do
      collection do
        get 'habilitar_calificar'
        post 'cambiar_capacidad'
        post 'cambiar_profe_seccion'
        post 'agregar_profesor_secundario'
        get 'importar_secciones'
      end
      member do
        get 'desasignar_profesor_secundario'
        get 'seleccionar_profesor'
        post :calificar
        get 'descargar_notas'
        get 'habilitar_calificar'
      end
    end

    resources :asignaturas do
      member do
        get 'set_activa'
      end
    end

    resources :combinaciones
    resources :usuarios do
      collection do
        # post :index
        get :busquedas
      end
      member do
        get 'delete_rol'
        post 'set_estudiante'
        post 'set_administrador'
        post 'set_profesor'
        post 'cambiar_ci'
        get 'resetear_contrasena'
      end
    end
  end
  
  root to: 'visitors#index'
end
