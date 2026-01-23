require "ostruct"

# control organisations
class OrganisationsController < ApplicationController
  before_action :authenticate_admin!, only: :destroy
  before_action :authenticate_user!, except: %i[autocomplete index show]
  before_action :find, only: %i[edit geolocate show update]
  before_action :find_languages, only: %i[edit create]

  def index
    @organisation_count = Organisation.all.count
    @organisations = Organisation
                     .all
                     .select(:language_id, :name, :slug, :sponsorships_count)
                     .alphabetically
                     .paginate(page: permitted_show_params[:page], per_page: 50)
    @top_ten = Organisation
               .all
               .select(:name, :slug, :sponsorships_count)
               .by_popularity
               .limit(10)
    respond_to do |format|
      format.html
      format.json { render json: @organisations }
      format.geojson do
        @organisations = Organisation.all.alphabetically
        render geojson: @organisations
      end
    end
  end

  def autocomplete
    limit = params[:limit] || 5
    @organisations = nil
    q = params[:q]
    if q
      @organisations = Organisation.select(:id, :name).name_is(q).limit(limit)
      @organisations += Organisation.select(:id, :name).name_starts_with(q).alphabetically.limit(limit)
      @organisations += Organisation.select(:id, :name).name_contains(q).alphabetically.limit(limit)
      @organisations.uniq!
    end
    respond_to do |format|
      format.html { render html: @organisations.map { |organisation| "<li class=\"list-group-item\" role=\"option\" data-autocomplete-value=\"#{organisation.id}\">#{organisation.name}</li>" }.join.html_safe }
      format.json { render json: @organisations.as_json(only: %i[id name]) }
    end
  end

  def show
    params[:id].gsub!("oxfordshire_blue_plaques_scheme", "oxfordshire_blue_plaques_board")
        set_meta_tags description: "Blue plaques and historical markers from #{@organisation.name}"
    set_meta_tags open_graph: {
      title: "#{@organisation.name} plaques",
      description: @organisation.description
    }
    @main_photo = @organisation.main_photo
    set_meta_tags twitter: {
      title: "#{@organisation.name} plaques",
      image: {
        _: @main_photo ? @main_photo.file_url : view_context.root_url[0...-1] + view_context.image_path("openplaques-icon.png"),
        width: 100,
        height: 100
      }
    }
    zoom = params[:zoom].to_i
    @plaques_count = @organisation.plaques.count # size is 0
    @uncurated_count = @organisation.plaques.unconnected.size
    @curated_count = @plaques_count - @uncurated_count
    @percentage_curated = if @plaques_count.positive?
      ((@curated_count.to_f / @plaques_count) * 100).to_i
    else
      0
    end
    query = "SELECT people.gender, count(distinct person_id) as subject_count
      FROM sponsorships, personal_connections, people
      WHERE sponsorships.organisation_id = #{@organisation.id}
      AND sponsorships.plaque_id = personal_connections.plaque_id
      AND personal_connections.person_id = people.id
      GROUP BY people.gender"
    @gender = ActiveRecord::Base.connection.execute(query)
    @gender = @gender.map { |attributes| OpenStruct.new(attributes) }
    @subject_count = @gender.inject(0) { |sum, g| sum + g.subject_count }
    @gender.append(OpenStruct.new(gender: "tba", subject_count: @uncurated_count)) unless @uncurated_count.zero?
    @people = people(@organisation.plaques.connected)

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
  end

  def geolocate
    @organisation.geolocate!
    redirect_back(fallback_location: root_path)
  end

  def new
    @organisation = Organisation.new
  end

  def create
    @organisation = Organisation.new(permitted_params)
    if @organisation.save
      flash[:notice] = "Thanks for adding this organisation."
      redirect_to organisation_path(@organisation.slug)
    else
      render :new
    end
  end

  def update
    old_slug = @organisation.slug
    if params[:streetview_url] && params[:streetview_url] != ""
      point = help.geolocation_from(params[:streetview_url])
      if !point.latitude.blank? && !point.longitude.blank?
        params[:organisation][:latitude] = point.latitude
        params[:organisation][:longitude] = point.longitude
      end
    end
    if @organisation.update(permitted_params)
      flash[:notice] = "Updates to organisation saved."
      redirect_to organisation_path(@organisation.slug)
    else
      @organisation.slug = old_slug
      render :edit
    end
  end

  protected

  def find
    @organisation = Organisation.find_by!(slug: params[:id])
  end

  def find_languages
    @languages = Language.order(name: :desc)
  end

  def people(plaques)
    @people = []
    plaques.each do |p|
      p.people.each do |per|
        per.define_singleton_method(:plaques_count) do
          1
        end
        @people << per
      end
    end
    @people.uniq
  end

  private

  def help
    Helper.instance
  end

  # access helpers from controller
  class Helper
    include Singleton
    include PlaquesHelper
  end

  def permitted_params
    params.require(:organisation).permit(
      :description,
      :language_id,
      :latitude,
      :longitude,
      :max_latitude,
      :max_longitude,
      :min_latitude,
      :min_longitude,
      :name,
      :notes,
      :slug,
      :streetview_url,
      :website
    )
  end
end
