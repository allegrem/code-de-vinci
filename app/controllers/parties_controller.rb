class PartiesController < ApplicationController
  before_filter :check_login, :except => :index
  before_filter :get_partie_by_id, :except => [:index, :create, :new, :refresh, :refresh_chat, :add_chat_message]
  before_filter :get_donnees_partie, :except => [:index, :create, :new, :destroy, :refresh, :refresh_chat, :add_chat_message]
  layout "standard"
	

  def index
  	@title = "Liste des parties"
    @parties = Partie.all
  end



#============================================================================



  def show
    @title = @partie.nom
		
		@chat_messages = Chat.find(:all, :conditions => 
		                  ["partie_id = :partie_id", 
		                  {:partie_id => @partie.id}  ])
  end


#============================================================================



  def new
  	@title = "Nouvelle partie"
    @partie = Partie.new
    @partie.nom = "Partie " +  Time.now.to_s(:db)
  end


#============================================================================



  def create
    @partie = Partie.new(params[:partie])
    @partie.createur = session[:joueur_id]
    @partie.init

    if @partie.save
      redirect_to :action => "join", :id => @partie.id
    else
      render :action => "new"
    end
  end


#============================================================================



  def destroy
    if @partie.createur == session[:joueur_id]
    	JoueursPartie.destroy_all(["partie_id = :partie_id", {:partie_id => params[:id]} ])
			Chat.destroy_all(["partie_id = :partie_id", {:partie_id => params[:id]} ])
    	@partie.destroy
    else
    	flash[:notice] = "Vous n'avez pas le droit de supprimer une partie créée par un autre joueur !!"
    end

    redirect_to(parties_url)
  end
  
  
#============================================================================  
  
  
  def join
  	#on vérifie qu'il reste de la place dans la partie
  	if @partie.nbre_joueur == @partie.joueurs.count
  	  flash[:notice] = "Cette partie a déjà commencé !"
			redirect_to :action => "show", :id => params[:id]
			return
    end
  	
  	#on vérifie que le joueur n'a pas encore rejoint la partie
		if partie_joined(@partie, @joueur)
			flash[:notice] = "Vous avez déjà rejoint cette partie !"
			redirect_to :action => "show", :id => params[:id]
			return
	  end
  	
  	#on ajoute le joueur à la liste des joueurs
  	@partie.joueurs << @joueur
  	
  	#on annonce l'arrivée du nouveau joueur
  	add_message (@joueur.pseudo + " a rejoint la partie !")
		partie_increase_update
  	@partie.save
  	
  	redirect_to :action => "show", :id => params[:id]
  end
  
  
#============================================================================  
  
  
  
  def piocher
  	#on vérifie si le joueur a le droit de piocher
    unless (@partie.joueurs[@partie.tour].id == @joueur.id  &&  @partie.phase == 0)	||  @code_joueur.length < 4
      flash[:notice] = "Vous ne pouvez pas piocher maintenant !"
      redirect_to :action => "show", :id => params[:id]
      return
    end
    
    #on retire le jeton de la pioche
    @pioche = @partie.pioche.split("-")
    @jeton_pioche = @pioche[params[:jeton_id].to_i]
    @pioche.delete(@jeton_pioche)
    @partie.pioche = @pioche.join("-")
    
    #on ajoute à la bonne place le jeton pioché à la main du joueur
		i = 0
		if @code_joueur != [] && @code_joueur != nil
			@code_joueur.each do |j|
				if j[/[0-9]*/].to_i > @jeton_pioche[/[0-9]*/].to_i  ||
							(j[/[0-9]*/].to_i == @jeton_pioche[/[0-9]*/].to_i  &&  j[-2,1] == "B")
					@code_joueur.insert(i, @jeton_pioche)
					break
				end
				i = i+1
			end
		end
		@code_joueur << @jeton_pioche  if i == @code_joueur.length #on ajoute le jeton à la fin s'il n'a pas été ajouté dans la boucle
    @joueur_partie.code = @code_joueur.join("-")
    
    #on retient ce jeton comme dernier pioché
    @joueur_partie.dernier_jeton = @jeton_pioche
    @joueur_partie.save
    
    #on regarde si la partie peut commencer (si le compte tour n'a pas été lancé)
    if @partie.tour == -1  &&  @partie.nbre_joueur == @partie.joueurs.count
    	start = true
    	JoueursPartie.find(:all, :conditions => ["partie_id = :partie_id", {:partie_id => params[:id]} ] ).each do |c|
    		if c.code == nil  ||  c.code.split("-").length < 4
    			start = false
    		end
    	end
    	#si la partie peut commencer, on choisit le premier joueur au hasard
    	if start == true
    		@partie.tour = rand(@partie.nbre_joueur - 1)
    		@partie.phase = 0
    	end
    
    #si la partie a déjà commencé, on passe à la phase suivante (pour ne pas piocher deux fois de suite
    elsif @partie.tour != -1
    	@partie.phase = 1
    end
    
    #on annonce la couleur du jeton pioché par le joueur
    add_message( @joueur.pseudo + " a pioché un jeton " + get_txt_couleur(@jeton_pioche) )
		partie_increase_update
		@partie.save
		
		#on construit l'objet Highlight du jeton
		@highlight = [] #contiendra tous les highlights
		highlight = Highlight.new()
		highlight.id = 'jeton_'+session[:joueur_id].to_s+'_'+i.to_s
		highlight.bg = "#000000"  if @jeton_pioche[-2,1] == "N"
		highlight.bg = "#FFFFFF"  if @jeton_pioche[-2,1] == "W"
		highlight.color = "#ffff99"
		@highlight << highlight
  
  
    respond_to do |format|
      format.html { redirect_to :action => "show", :id => params[:id] }
      format.js { render "refresh_partie" }
     end
  end
  
  
  
  
#============================================================================ 
  
  
  
  
  def guess
  	#on récupère le jeton réel de l'adversaire dans la BDD
  	@adversaire_partie = get_joueur_partie(params[:joueur_id], @partie.id)
    @code_adversaire = get_code_joueur(@adversaire_partie)
    jeton_reel = @code_adversaire[params[:jeton_id].to_i]
		
		#on construit l'objet Highlight du jeton
		@highlight = [] #contiendra tous les highlights
		highlight = Highlight.new()
		highlight.id = 'jeton_'+params[:joueur_id]+'_'+params[:jeton_id]
		highlight.bg = "#000000"  if jeton_reel[-2,1] == "N"
		highlight.bg = "#FFFFFF"  if jeton_reel[-2,1] == "W"
    
    #on annonce la tentative du joueur
    message = @joueur.pseudo + " a proposé '" + params[:nbre_entre] + " " + get_txt_couleur(jeton_reel) + "' pour le " + (params[:jeton_id].to_i+1).to_s + "e jeton de " + Joueur.find(params[:joueur_id]).pseudo
    
    #on vérifie si le numéro entré est le bon
    if params[:nbre_entre] == jeton_reel[/[0-9]*/]
      #si c'est le bon numéro, on révèle le jeton
      jeton_revele = jeton_reel
      jeton_revele[-1,1] = "V"
      @code_adversaire[params[:jeton_id].to_i] = jeton_revele
      @adversaire_partie.code = @code_adversaire.join("-")
			
			#on highlightera ce jeton en vert
			highlight.color = "#00FF00"
      
      #on complète le message d'annonce
      message = message + ". Sa proposition est correcte ; il peut continuer à jouer." 
      
      #on incrémente le nombre de tentatives
      @partie.nbre_guess = @partie.nbre_guess + 1 
      
      #on regarde si le joueur est éliminé
      elimine = true
      @code_adversaire.each do |j|
        if j[-1,1] == "H"
          elimine = false
          break
        end
      end
      if elimine
        @adversaire_partie.en_jeu = false
        message = message + "<br />" + Joueur.find(@adversaire_partie.joueur_id).pseudo + " a été éliminé !"
        
        #on regarde s'il reste encore au moins deux joueurs en jeu
        joueurs_restants = JoueursPartie.find(:all, :conditions => 
            ["partie_id = :partie_id", 
            {:partie_id => @partie.id}  ]  )
        nbre_joueurs_restants = -1  #on part à -1 car le dernier joueur éliminé n'a pas encore été enregistré dans la BDD
        joueurs_restants.each do |j|
          if j.en_jeu == true
            nbre_joueurs_restants = nbre_joueurs_restants + 1  
            puts "214"
          end
        end
        puts 'nbre joueurs restants : ' + nbre_joueurs_restants.to_s
        if nbre_joueurs_restants == 1
          #on stoppe la partie
          @partie.tour = -1
          message = "<strong style='color:red'>"+@joueur.pseudo+" a remporté la partie !!</strong>"
        end
      end
      @adversaire_partie.save
      
    else
      #si c'est le mauvais numéro, on passe au joueur suivant
      @partie.passer_main
			
			#on highlightera ce jeton en rouge
			highlight.color = "#FF0000"
      
      #et on révèle le dernier jeton pioché par le joueur
      compteur = 0
      @code_joueur.each do |j| #on cherche le jeton à modifier
        if j == @joueur_partie.dernier_jeton
          jeton_visible = @joueur_partie.dernier_jeton
          jeton_visible[-1,1] = "V"
          @code_joueur[compteur] = jeton_visible
          break
        end
        compteur = compteur + 1
      end
      @joueur_partie.code = @code_joueur.join("-")
      @joueur_partie.save
			
			#on highlight le jeton révélé
			highlight_joueur = Highlight.new()
			highlight_joueur.id = 'jeton_'+session[:joueur_id].to_s+'_'+compteur.to_s
			highlight_joueur.bg = "#000000"  if @joueur_partie.dernier_jeton[-2,1] == "N"
			highlight_joueur.bg = "#FFFFFF"  if @joueur_partie.dernier_jeton[-2,1] == "W"
			highlight_joueur.color = "#FF00000"
			@highlight << highlight_joueur
      
		  #on complète le message d'annonce
      message = message + ". Sa proposition est fausse ; la main passe au joueur suivant."
    end
    
    
		add_message (message)
		partie_increase_update
    @partie.save
		
		@highlight << highlight
    
    @adversaires = get_adversaires #on recharge les jeux des adversaires
    
    respond_to do |format|
      format.html { redirect_to :action => "show", :id => params[:id] }
      format.js { render "refresh_partie" }
    end
  end
  
  
  
  
  
  
#============================================================================   
  
  
  
  
  
  def passer
    @partie.passer_main
    add_message (@joueur.pseudo + " a passé la main.")
		partie_increase_update
    @partie.save
		
    
    respond_to do |format|
      format.html { redirect_to :action => "show", :id => params[:id] }
      format.js { render "refresh_partie" }
    end
  end
  
  
  
  
  
  
#============================================================================   
  
  
  
  
  def refresh
		get_partie_by_id
		if @partie.update_id == params[:partie_update_id].to_i
			respond_to do |format|
				format.js { render :text => "" }
			end
		
		else
			joueur_session
			@joueur_partie = get_joueur_partie(session[:joueur_id], params[:id])
			get_donnees_partie
			respond_to do |format|
				format.js { render "refresh_partie" }
			end
		end
  end
	
	
	

#============================================================================   
  
	
	
	def add_chat_message
		message = "<strong>"+@joueur.pseudo+":</strong> "+params[:message]
		@chat_message = Chat.new(:message => message, :partie_id => params[:id])
		@chat_message.save
		
		@chat_messages = []
		@chat_messages << @chat_message
	end
  



#============================================================================   
  
	
	
	
	
	def refresh_chat
		@chat_messages = Chat.find(:all, :conditions => 
		                  ["id > :last_id  and  partie_id = :partie_id", 
		                  {:last_id => params[:last_chat_id], :partie_id => params[:id]}  ])
		@last_chat_id = params[:last_chat_id]
	end
	
	
	
#============================================================================
#============================================================================
#============================================================================


  private
  
  def get_partie_by_id
    @partie = Partie.find(params[:id])
  end
  
  
  
  def get_joueur_partie(joueur_id, partie_id)
    JoueursPartie.find(:first, :conditions => 
                ["joueur_id = :joueur_id  and  partie_id = :partie_id", 
                {:joueur_id => joueur_id, :partie_id => partie_id}  ]  )
  end
  
  
  
  def get_code_joueur(joueur_partie)
    code_joueur = []
    code_joueur = joueur_partie.code.split("-")  if joueur_partie != nil && joueur_partie.code != nil
    code_joueur
  end
  
  
  
  def get_txt_couleur(jeton)
    couleur = "blanc"
    couleur = "noir"   if jeton[-2,1] == "N"
    couleur
  end
  
  
  def get_adversaires
    JoueursPartie.find(:all, :conditions => 
            ["joueur_id != :joueur_id  and  partie_id = :partie_id", 
            {:joueur_id => session[:joueur_id], :partie_id => @partie.id}  ]  )
  end
  
  
  def get_donnees_partie
    @pioche = @partie.pioche.split("-")
    @adversaires = get_adversaires
    @partie_joined = partie_joined(@partie, session[:joueur_id])
    
    #on récupère le joueur connecté et son code
    if @partie_joined
      @joueur_partie = get_joueur_partie(@joueur.id, @partie.id)
      @code_joueur = get_code_joueur(@joueur_partie)
    end
  end

	
	def partie_increase_update
		@partie.update_id = @partie.update_id + 1
	end
	
	
	def add_message(message)
		message = "<em>"+message+"</em>"
		@chat_message = Chat.new(:message => message, :partie_id => @partie.id)
		@chat_message.save
	end
end
