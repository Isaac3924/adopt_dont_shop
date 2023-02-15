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
      @petition_pet6 = PetitionPet.create!(petition_id: @petition2.id, pet_id: @pet1.id)
    end

    it 'When I am at admin/petitions show page I see buttons to approve pets' do
      visit "/admin/petitions/#{@petition1.id}"

      expect(page).to have_button("Approve: #{@pet1.name}")
      expect(page).to have_button("Approve: #{@pet2.name}")
      expect(page).to have_button("Approve: #{@pet3.name}")
      expect(page).to_not have_button("Approve: #{@pet4.name}")
      expect(page).to_not have_button("Approve: #{@pet5.name}")
    end

    it 'When I am at another admin/petitions show page I see buttons to approve pets' do
      visit "/admin/petitions/#{@petition2.id}"
      
      expect(page).to have_button("Approve: #{@pet4.name}")
      expect(page).to_not have_button("Approve: #{@pet5.name}")
      expect(page).to_not have_button("Approve: #{@pet2.name}")
    end
    
    it 'When I click the approve button I arrive at admin/petitions show page' do
      visit "/admin/petitions/#{@petition1.id}"
      click_button "Approve: #{@pet1.name}"
    
      expect(page).to have_current_path("/admin/petitions/#{@petition1.id}")
    end

    it 'When I click the approve button I arrive at a new admin show page that shows 
      that the pet has been approved and no longer has a button' do
      visit "/admin/petitions/#{@petition1.id}"
      click_button "Approve: #{@pet1.name}"
    
      expect(page).to_not have_button("Approve: #{@pet1.name}")
      expect(page).to have_content("#{@pet1.name}: Approved")
    end

    it 'When I am at admin/petitions show page I see buttons to reject pets' do
      visit "/admin/petitions/#{@petition1.id}"
      
      expect(page).to have_button("Reject: #{@pet1.name}")
      expect(page).to have_button("Reject: #{@pet2.name}")
      expect(page).to have_button("Reject: #{@pet3.name}")
      expect(page).to_not have_button("Reject: #{@pet4.name}")
      expect(page).to_not have_button("Reject: #{@pet5.name}")
    end
    
    it 'When I click the reject button I arrive at admin/petitions show page' do
      visit "/admin/petitions/#{@petition1.id}"
      click_button "Reject: #{@pet1.name}"
      
      expect(page).to have_current_path("/admin/petitions/#{@petition1.id}")
    end

    it 'When I click the reject button I arrive at a new admin show page that shows 
      that the pet has been rejected and no longer has a button' do
      visit "/admin/petitions/#{@petition1.id}"
      
      within ("##{@pet1.id}") do
        click_button "Reject: #{@pet1.name}"
        expect(page).to_not have_button("Reject: #{@pet1.name}")
        expect(page).to have_content("#{@pet1.name}: Rejected")
      end
    end

    it 'When I approve a pet on an admin application show page and I visit another admin
        application show page that also has it as a relation, I do not see that the pet has
        been accpeted, instead I see the buttons to approve or reject it.' do
      visit "/admin/petitions/#{@petition1.id}"
      
      within ("##{@pet1.id}") do
        click_button "Approve: #{@pet1.name}"
      end
      
      visit "/admin/petitions/#{@petition2.id}"

      within ("##{@pet1.id}") do
        expect(page).to have_button("Approve: #{@pet1.name}")
        expect(page).to have_button("Reject: #{@pet1.name}")
        expect(page).to_not have_content("#{@pet1.name}: Approved")
        expect(page).to_not have_content("#{@pet1.name}: Rejected")
      end
    end
  end
end