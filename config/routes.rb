Rails.application.routes.draw do
  

  resources :visitors, only: [:index] do
    collection do
      post :validar
      get 'olvido_clave'
      get 'un_rol'
      get 'seleccionar_rol'
      get 'cerrar_sesion'
      post 'olvido_clave_guardar'
      get 'olvido_clave_guardar'
      # get 'usuario'
    end
    member do
    end
  end

  scope module: :admin do

    resources :comentarios do
      member do
        get 'habilitar'
      end
    end

    get '/importador/seleccionar_archivo'
    get '/importador/index'
    get '/importador/seleccionar_archivo_secciones'
    get '/importador/seleccionar_archivo_profesores'
    get '/importador/seleccionar_archivo_estudiantes'
    post '/importador/vista_previa'
    post '/importador/importar'
    post '/importador/importar_seccion'
    post '/importador/importar_profesores'
    post '/importador/importar_estudiantes'

    resources :administradores, only: :index

    resources :principal_admin, only: :index do
      collection do
        get 'index2'
        get 'set_tab'
        post 'cambiar_sesion_periodo'
      end
      member do 
        get 'ver_seccion_admin'
        post 'cambiar_estudiante_escuela'
        post 'agregar_estudiante_escuela'
      end
    end

    resources :principal_profesor, only: :index 
    resources :principal_estudiante, only: :index do
      post 'actualizar_idiomas'
    end

    resources :tipo_secciones, :tipoasignaturas, :tipo_calificaciones, :tipo_estado_inscripciones

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
        get 'listado_seccion_excel'
        get 'notas_seccion'
        get 'notas_seccion_online'
        get 'inscritos_escuela_periodo'
      end
    end

    resources :inscripcionsecciones do
      collection do
        get 'buscar_estudiante'
        get :seleccionar
        post :inscribir
        post :crear
        post 'cambiar_calificacion' 
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
        get 'set_pci'
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
