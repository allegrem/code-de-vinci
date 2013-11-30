# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :joueur_session, :except => ["refresh", "refresh_chat"]

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def check_login #vérifie si le joueur est connecté
    if session[:joueur_id] == nil
      session[:original_uri] = request.request_uri
      flash['notice'] = "Veuillez vous connecter pour accéder à cette page"
      redirect_to :controller => "joueurs", :action => "login"
    end
  end
  
  def joueur_session
    if session[:joueur_id] != nil
      @joueur = Joueur.find(session[:joueur_id])
    else
      @joueur = nil
    end
  end
  
  def partie_joined (partie, joueur_id)
    partie.joueurs.each do |j|
      if j.id == joueur_id
	      return true
      end
    end
    return false
  end
end
