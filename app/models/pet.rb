class Pet < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true, numericality: true
  belongs_to :shelter
  has_many :petition_pets
  has_many :petitions, through: :petition_pets

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def self.petition_status(petitions)
    petitions.each do |petition|
      return Petition.find(petition.id).status
    end
  end
end
