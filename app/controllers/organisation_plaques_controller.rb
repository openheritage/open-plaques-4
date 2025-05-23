# show plaques for an organisation
class OrganisationPlaquesController < ApplicationController
  before_action :find, only: :show

  def show
    set_meta_tags description: "Blue plaques and historical markers from #{@organisation.name}"
    set_meta_tags open_graph: {
      title: "#{@organisation.name} plaques",
      description: @organisation.description
    }
    @main_photo = @organisation.main_photo
    set_meta_tags twitter: {
      title: "#{@organisation.name} plaques",
      image: {
        _: @main_photo ? @main_photo.file_url : view_context.root_url[0...-1] + view_context.image_path("openplaques.png"),
        width: 100,
        height: 100
      }
    }
    zoom = params[:zoom].to_i

    @display = "plaques"
    if zoom.positive?
      @plaques = @organisation.plaques.tile(zoom, params[:x].to_i, params[:y].to_i, params[:filter])
    elsif params[:data] && params[:data] == "simple"
      @plaques = @organisation.plaques.all(conditions: conditions, order: "created_at DESC", limit: limit)
    elsif params[:data] && params[:data] == "basic"
      @plaques = @organisation.plaques.all(select: %i[id latitude longitude inscription])
    elsif params[:filter] && params[:filter] != ""
      begin
        @plaques = if request.format == "html"
                     @organisation.plaques.send(params[:filter].to_s).paginate(page: permitted_show_params[:page], per_page: 50)
        else
                     @organisation.plaques.send(params[:filter].to_s)
        end
        @display = params[:filter].to_s
      rescue # an unrecognised filter method
        @plaques = if request.format == "html"
                     @organisation.plaques.paginate(page: permitted_show_params[:page], per_page: 50)
        else
                     @organisation.plaques
        end
      end
    else
      @plaques = if request.format == "html"
                   @organisation.plaques.paginate(page: permitted_show_params[:page], per_page: 50)
      else
                   @organisation.plaques
      end
    end
    respond_to do |format|
      format.html { render "organisations/plaques/show" }
      format.json { render json: @plaques }
      format.geojson { render geojson: @plaques, parent: @organisation }
      format.csv do
        send_data(
          "\uFEFF#{PlaqueCsv.new(@plaques).build}",
          type: "text/csv",
          filename: "open-plaques-#{@organisation.slug}-#{Date.today}.csv",
          disposition: "attachment"
        )
      end
    end
  end

  protected

  def find
    @organisation = Organisation.find_by!(slug: params[:organisation_id])
  end
end
