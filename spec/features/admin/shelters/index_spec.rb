require 'rails_helper'

RSpec.describe 'the admin shelters index' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)

    @pet_1 = @shelter_2.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_3.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)

    @petition_1 = Petition.create!(name: 'John', street_address: '1 Sesame St', city: 'Denver',
                    state: 'CO', zip_code: 12345, description: 'I like dogs', status: 'Pending')
    @petition_2 = Petition.create!(name: 'Nhoj', street_address: '2 Sesame St', city: 'Renved',
                    state: 'OC', zip_code: 54321, description: 'Dogs like I', status: 'Pending')
    @petition_3 = Petition.create!(name: 'Bill', street_address: '2 Sesame St', city: 'Nedver',
                    state: 'CA', zip_code: 89876, description: '', status: 'In Progress') 
    
    @petition_pet_1 = PetitionPet.create!(petition_id: @petition_3.id, pet_id: @pet_1.id)
    @petition_pet_2 = PetitionPet.create!(petition_id: @petition_2.id, pet_id: @pet_2.id)
    @petition_pet_3 = PetitionPet.create!(petition_id: @petition_1.id, pet_id: @pet_3.id)
    @petition_pet_4 = PetitionPet.create!(petition_id: @petition_3.id, pet_id: @pet_4.id)
  end

  it 'I see all shelters in reverse alphabetical order by name' do
    visit "/admin/shelters"

    expect(@shelter_2.name).to appear_before(@shelter_3.name)
    expect(@shelter_2.name).to appear_before(@shelter_1.name)
    expect(@shelter_3.name).to appear_before(@shelter_1.name)
    expect(@shelter_1.name).to_not appear_before(@shelter_2.name)
    expect(@shelter_1.name).to_not appear_before(@shelter_3.name)
    expect(@shelter_3.name).to_not appear_before(@shelter_2.name)
  end

  it 'I see a section for shelters with pending applications' do
    visit "/admin/shelters"

    save_and_open_page
    expect(page).to have_content('Shelters with Pending Applications')
    expect(page).to have_content("Pending: #{@shelter_1.name}")
    expect(page).to have_content("Pending: #{@shelter_3.name}")
    expect(page).to_not have_content("Pending: #{@shelter_2.name}")
  end
end
