# edit a plaque description
class PlaqueDescriptionController < PlaqueDetailsController
  before_action :authenticate_user!

  def edit
    render "plaques/description/edit"
  end
end
