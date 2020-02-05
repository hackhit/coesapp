module Admin
	class AutorizadasController < ApplicationController
		def index
			@autorizadas = Autorizada.all.limit(100)#.order([controlador: :desc, accion: :desc])
		end

	end
end