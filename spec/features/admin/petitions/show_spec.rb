require 'rails_helper'

RSpec.describe 'admin applications show page', type: :feature do
  describe 'As a visitor' do
    before :each do
      @petition1 = Petition.create!(name: 'John', street_address: '1 Sesame St', city: 'Denver',
                    state: 'CO', zip_code: 12345, description: 'I like dogs', status: 'In Progress')
      @petition2 = Petition.create!(name: 'Nhoj', street_address: '2 Sesame St', city: 'Renved',
                    state: 'OC', zip_code: 54321, description: 'Dogs like I', status: 'Pending')
      @petition3 = Petition.create!(name: 'Bill', street_address: '2 Sesame St', city: 'Nedver',
                    state: 'CA', zip_code: 89876, description: '', status: 'Approved') 
      @shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
      @pet1 = Pet.create!(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: @shelter.id)
      @pet2 = Pet.create!(name: 'Dooby', age: 3, breed: 'Greater Dane', adoptable: true, shelter_id: @shelter.id)
      @pet3 = Pet.create!(name: 'Ruf', age: 5, breed: 'Greatest Dane', adoptable: true, shelter_id: @shelter.id)
      @pet4 = Pet.create!(name: 'Rufus', age: 2308732, breed: 'Lesser Dane', adoptable: true, shelter_id: @shelter.id)
      @pet5 = Pet.create!(name: 'Sufur', age: 230, breed: 'Less Dane', adoptable: true, shelter_id: @shelter.id)
      @petition_pet1 = PetitionPet.create!(petition_id: @petition1.id, pet_id: @pet1.id)
      @petition_pet2 = PetitionPet.create!(petition_id: @petition1.id, pet_id: @pet2.id)
      @petition_pet3 = PetitionPet.create!(petition_id: @petition1.id, pet_id: @pet3.id)
      @petition_pet4 = PetitionPet.create!(petition_id: @petition2.id, pet_id: @pet4.id)
      @petition_pet5 = PetitionPet.create!(petition_id: @petition3.id, pet_id: @pet5.id)
    end

    it 'I can see the status indicator and cannot adopt another pet if the status is pending' do
      visit "/admin/applications/#{@petition1.id}"
      save_and_open_page
      expect(page).to have_button("Approve: #{@pet1.name}")
      expect(page).to have_button("Approve: #{@pet2.name}")
      expect(page).to have_button("Approve: #{@pet3.name}")
      expect(page).to_not have_button("Approve: #{@pet4.name}")
      expect(page).to_not have_button("Approve: #{@pet5.name}")
    end
  end
end