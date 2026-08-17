# control Counties
class CountiesController < ApplicationController
  def show
    @county = params[:id]
    @areas = Area.county(@county)
    sw_corner = [ @areas.pluck(:min_longitude).compact.min, @areas.pluck(:min_latitude).compact.min ]
    ne_corner = [ @areas.pluck(:max_longitude).compact.max, @areas.pluck(:max_latitude).compact.max ]
    @bbox_array = [ sw_corner, ne_corner ]
    @center_point_array = [ @areas.pluck(:longitude).compact.max, @areas.pluck(:latitude).compact.max ]
    @plaques = Plaque.where(area_id: @areas.map(&:id))
    @plaques_count = @plaques.count # size is 0
    @uncurated_count = @plaques.unconnected.size
    @curated_count = @plaques_count - @uncurated_count
    @percentage_curated = if @plaques_count.positive?
                            ((@curated_count.to_f / @plaques_count) * 100).to_i
    else
                            0
    end
    respond_to do |format|
      format.html
      format.json { render json: @areas }
      format.geojson { render geojson: @plaques }
    end
  end
end
