class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.order_by_reverse_alphabet

    @pending_apps = Shelter.find_shelters_with_pending_applications
  end
end