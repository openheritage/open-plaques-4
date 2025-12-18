# edit a plaque series
class PlaqueSeriesController < PlaqueDetailsController
  def edit
    @series = Series.alphabetically
    render "plaques/series/edit"
  end
end
