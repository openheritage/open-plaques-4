# control Counties
class CountiesController < ApplicationController
  def show
    @county = params[:id]
    @areas = Area.county(params[:id])
    @bbox_array = @areas.random&.bbox_array
    @center_point_array = @areas.random&.center_point_array
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
