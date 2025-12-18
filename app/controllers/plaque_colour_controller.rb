# edit plaque colour
class PlaqueColourController < PlaqueDetailsController
  def edit
    @colours = Colour.alphabetically
    render "plaques/colour/edit"
  end
end
