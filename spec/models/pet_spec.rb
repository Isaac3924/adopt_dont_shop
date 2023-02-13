require 'rails_helper'

RSpec.describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to(:shelter) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age) }
  end

  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @pet_2 = @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 3, adoptable: false)
    @petition_1 = Petition.create!(name: 'John', street_address: '1 Sesame St', city: 'Denver',
      state: 'CO', zip_code: 12345, description: 'I like dogs', status: 'Pending')
    @petition_2 = Petition.create!(name: 'Nhoj', street_address: '2 Sesame St', city: 'Renved',
      state: 'OC', zip_code: 54321, description: 'Dogs like I', status: 'Pending')
    @petition_3 = Petition.create!(name: 'Bill', street_address: '2 Sesame St', city: 'Nedver',
      state: 'CA', zip_code: 89876, description: '', status: 'In Progress')   

    @petition_pet_1 = PetitionPet.create!(petition_id: @petition_1.id, pet_id: @pet_1.id)
    @petition_pet_2 = PetitionPet.create!(petition_id: @petition_2.id, pet_id: @pet_2.id)
    @petition_pet_3 = PetitionPet.create!(petition_id: @petition_3.id, pet_id: @pet_3.id)
  end

  describe 'class methods' do
    describe '#search' do
      it 'returns partial matches' do
        expect(Pet.search("Claw")).to eq([@pet_2])
      end
    end

    describe '#adoptable' do
      it 'returns adoptable pets' do
        expect(Pet.adoptable).to eq([@pet_1, @pet_2])
      end
    end

    describe "#petition_status" do
      it "returns status of application on pets" do
        expect(Pet.petition_status(@pet_1.petitions)).to eq("Pending")
        expect(Pet.petition_status(@pet_2.petitions)).to eq("Pending")
        expect(Pet.petition_status(@pet_3.petitions)).to eq("In Progress")
      end
    end
  end

  describe 'instance methods' do
    describe '.shelter_name' do
      it 'returns the shelter name for the given pet' do
        expect(@pet_3.shelter_name).to eq(@shelter_1.name)
      end
    end
  end
end
