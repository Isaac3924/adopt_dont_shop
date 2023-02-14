class AdminPetitionsController < ApplicationController
  def show
    @petition = Petition.find(params[:id])
    @pets = @petition.pets
    @petition_pets = @petition.petition_pets
  end

  def update
    @petition = Petition.find(params[:id])
    @petition_pet = PetitionPet.find(params[:pet_id])
    @petition_pet.update!(admin_petition_pets_params)
    redirect_to "/admin/petitions/#{@petition.id}"
  end

  private

  def admin_petition_pets_params
    params.permit(:pet_id, :status)
  end
end