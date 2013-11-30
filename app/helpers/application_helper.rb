# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def partie_joined (partie, joueur_id)
    partie.joueurs.each do |j|
      if j.id == joueur_id
	      return true
      end
    end
    return false
  end
end
