module Admin
	class AutorizadasController < ApplicationController
		before_action :filtro_logueado
		before_action :filtro_admin_altos!

		def index
			@autorizadas = Autorizada.all.limit(100)#.order([controlador: :desc, accion: :desc])
		end

		def set
			if autorizada = Autorizada.where(restringida_id: params[:id], usuario_id: params[:usuario_id]).first

				respond_to do |format|
					if autorizada.destroy
						format.json {render json: 'Desautorizado', status: :ok }
					else
						format.json {render json: 'Error al intentar desauthorizar', status: :unprocessable_entity }
					end
				end
			else
				autorizada = Autorizada.new(restringida_id: params[:id], usuario_id: params[:usuario_id])

				respond_to do |format|
					if autorizada.save
						format.json {render json: 'Authorizado', status: :ok }
					else
						format.json {render json: 'Error al intentar autorizar', status: :unprocessable_entity }
					end
				end
			end
			
		end

	end
end