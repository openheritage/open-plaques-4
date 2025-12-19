# edit a Plaque language
class PlaqueLanguageController < PlaqueDetailsController
  def edit
    @languages = Language.alphabetically
    render "plaques/language/edit"
  end
end
