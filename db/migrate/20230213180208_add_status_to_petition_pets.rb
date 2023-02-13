class AddStatusToPetitionPets < ActiveRecord::Migration[5.2]
  def change
    add_column :petition_pets, :status, :string
  end
end
