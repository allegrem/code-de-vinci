class JoueursController < ApplicationController
  before_filter :check_login, :except => [:login, :new, :create]
  layout "standard"

  def index
    @title = "Liste des joueurs"
    @joueurs = Joueur.all
  end


  def show
    @joueur = Joueur.find(params[:id])
    @title = "Profil de " + @joueur.pseudo
  end


  def new
    @title = "Inscription"
    @joueur = Joueur.new
  end



  def create
    @joueur = Joueur.new(params[:joueur])

    if @joueur.save
      flash[:notice] = 'Joueur was successfully created.'
      session[:joueur_id] = @joueur.id #on connecte le joueur
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end


  def destroy
    @joueur = Joueur.find(params[:id])
    @joueur.destroy
    
    session[:joueur_id] = nil #on déconnecte le joueur

    redirect_to :controller => "index"
  end
  
  
  def login
    @title = "Login"
    
    if session[:joueur_id] != nil
      flash[:notice] = "Vous êtes déjà connecté !"
      redirect_to :controller => "parties"
    end
    
    if request.post?
      joueur = Joueur.auth(params[:pseudo], params[:password])
      if joueur
        session[:joueur_id] = joueur.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to (uri || {:controller => "index"}) #on redirige vers la page demandée ou vers l'accueil
      else
        flash.now[:notice] = "Mauvais pseudo/mot de passe !"
      end
    end
  end
  
  
  def logout
    session[:joueur_id] = nil
    flash[:notice] = "Vous êtes déconnecté !"
    redirect_to :controller => "index"
  end
end
