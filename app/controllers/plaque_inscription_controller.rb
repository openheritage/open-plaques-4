# edit plaque inscriptions
class PlaqueInscriptionController < PlaqueDetailsController
  def edit
    @languages = Language.alphabetically
    render "plaques/inscription/edit"
  end
end
