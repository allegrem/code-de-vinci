class Partie < ActiveRecord::Base
  has_many :joueurs_parties
  has_many :joueurs, :through => :joueurs_parties
  
  
  def init
    #on crée les jetons
    jetons = []
    numero = 0
    12.times do
      jetons << numero.to_s + "BH"
      jetons << numero.to_s + "NH"
      numero = numero + 1 
    end
    
    #on mélange les jetons
    100.times do
      pos_jeton1 = rand(jetons.length - 1)
      pos_jeton2 = rand(jetons.length - 1)
      jeton1 = jetons[pos_jeton1]
      jetons[pos_jeton1] = jetons[pos_jeton2]
      jetons[pos_jeton2] = jeton1
    end
    
    #on met les jetons mélangés dans la bdd
    self.pioche = jetons.join("-")
    
    #on initialise qq variables
    self.nbre_guess = 0
    self.phase = 0
    
    #on met à jour la bdd
    self.save
  end
  
  
  def passer_main
    self.tour = self.tour + 1
    if self.tour == self.nbre_joueur
      self.tour = 0 #on remet le compte tour à 0 quand on arrive au dernier joueur
    end
    
    joueur_partie = JoueursPartie.find(:first, :conditions => 
                ["joueur_id = :joueur_id  and  partie_id = :partie_id", 
                {:joueur_id => self.joueurs[self.tour].id, :partie_id => self.id}  ]  )
    if joueur_partie.en_jeu == false
      self.passer_main
    end
    
    self.phase = 0    if self.pioche != "" #on passe à la phase 1 (piocher un jeton) que si la pioche n'est pas vide
    
    self.nbre_guess = 0
  end
end



class Highlight
		attr_accessor :id, :color, :bg
	end


