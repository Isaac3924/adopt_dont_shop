class AdminPetitionsController < ApplicationController
  def show
    @petition = Petition.find(params[:id])
    @pets = @petition.pets
    # binding.pry
  end

  def update
    @petition = Petition.find(params[:id])
  end
end