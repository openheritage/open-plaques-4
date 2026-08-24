# list photographers
class PhotographersController < ApplicationController
  def index
    @photographers_count = Photographer.all.count
    @photographers = Photographer.top50
    description = "Photographers of blue plaques"
    set_meta_tags noindex: true
    set_meta_tags description: description
    set_meta_tags open_graph: {
      type: :website,
      url: url_for(only_path: false),
      title: "Plaque hunters",
      description: description
    }
    set_meta_tags twitter: {
      card: "summary_large_image",
      site: "@openplaques",
      title: description
    }
    @chart_data = {
      labels: @photographers.map { |p| "#{p.rank}. #{p.id}" },
      datasets: [ {
        label: "Photographed plaques",
        backgroundColor: "transparent",
        borderColor: "#3B82F6",
        data: @photographers.map(&:photos_count)
      } ]
    }
    respond_to do |format|
      format.html
      format.json { render json: @photographers }
    end
  end
end
