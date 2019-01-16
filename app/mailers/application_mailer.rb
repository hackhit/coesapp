class ApplicationMailer < ActionMailer::Base
  default from: "COES-FHE <soporte.coes.fhe@gmail.com>"

  def olvido_clave(usuario)
    @nombre = usuario.nombre_completo
    @clave = usuario.password
    mail(:to => usuario.email, :subject => "COES-FHE - Recordatorio de clave")
  end  
end
