class Adddefaultstatuspetitionpets < ActiveRecord::Migration[5.2]
  def change
    change_column_default :petition_pets, :status, "Pending"
  end
end
