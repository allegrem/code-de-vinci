class Joueur < ActiveRecord::Base
  has_many :joueurs_parties
  has_many :parties, :through => :joueurs_parties
  

  validates_presence_of   :pseudo
  validates_uniqueness_of :pseudo
  
  attr_accessor :password_confirm
  validates_confirmation_of :password
  
  validate  :password_non_vide
  
  
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    new_salt
    self.hashed_password = Joueur.crypt_password(self.password, self.salt)
  end
  
  
  
  private
  
  def password_non_vide
    errors.add(:password, "Mot de passe manquant") if hashed_password.blank?
  end
  
  def self.crypt_password(password, salt)
    string_to_hash = password + "catane" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def self.auth(pseudo, password)
    joueur = self.find_by_pseudo(pseudo)
    if joueur
      password_entre = crypt_password(password, joueur.salt)
      if joueur.hashed_password != password_entre
        joueur = nil
       end
     end
     joueur
  end
end
