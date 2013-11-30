class IndexController < ApplicationController
  layout "standard"
  
  
  def index
    @title = "Bienvenue"
    @parties_en_cours = Partie.find(:all, :conditions => ["tour != '-1'"])
    @parties_en_attente = Partie.find(:all, :conditions => ["tour = '-1'"])
    if session[:joueur_id] != nil
      @parties_joueur = Joueur.find(session[:joueur_id]).parties
    end
  end
end
