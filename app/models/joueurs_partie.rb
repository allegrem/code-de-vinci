class JoueursPartie < ActiveRecord::Base
  belongs_to :joueur
  belongs_to :partie
end
