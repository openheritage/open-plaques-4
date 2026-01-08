# control Areas
class AreasController < ApplicationController
  before_action :authenticate_admin!, only: :destroy
  before_action :authenticate_user!, except: %i[autocomplete index show update]
  before_action :find_country, only: %i[index new show create edit update destroy geolocate]
  before_action :find, only: %i[show edit update destroy geolocate]
  before_action :streetview_to_params, only: :update

  def autocomplete
    limit = params[:limit] || 5
    country_id = params[:country_id]
    @areas = {}
    q = params[:q]
    if q
      @areas = Area.select(:id, :name, :country_id).name_is(q).includes(:country).limit(limit)
      @areas += Area.select(:id, :name, :country_id).name_starts_with(q).includes(:country).limit(limit)
      @areas += Area.select(:id, :name, :country_id).name_contains(q).includes(:country).limit(limit)
      @areas += Area.select(:id, :name, :country_id).where(country_id: country_id).name_starts_with(q).includes(:country).limit(limit) if country_id
      @areas.uniq!
    end
    respond_to do |format|
      format.html { render html: @areas.map { |area| "<li class=\"list-group-item\" role=\"option\" data-autocomplete-value=\"#{area.id}\">#{area.full_name}</li>" }.join.html_safe }
      format.json do
        render json: @areas.as_json(
          only: %i[id name country_id],
          include: { country: { only: [ :name ] } }
        )
      end
    end
  end

  def new
    @area = @country.areas.new
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @area }
      format.geojson { render geojson: @area }
    end
  end

  def create
    @area = @country.areas.new(permitted_params)
    if @area.save
      redirect_to country_area_path(@area.country_alpha2, @area.slug)
    else
      render :new
    end
  end

  def destroy
    @area.destroy
    redirect_to country_path(@country)
  end

  def edit
    @countries = Country.all.alphabetically.select(:id, :name)
  end

  def update
    flash[:notice] = "Area was successfully updated." if @area.update!(permitted_params)
    redirect_back(fallback_location: root_path)
  end

  def geolocate
    unless @area.geolocated?
      @mean = Helper.instance.find_mean(@area.plaques.geolocated.random(50))
      @area.latitude = @mean.latitude
      @area.longitude = @mean.longitude
      @area.save
    end
    redirect_back(fallback_location: root_path)
  end

  protected

  def find_country
    @country = Country.find_by!(alpha2: params[:country_id])
  end

  def find
    @area = @country.areas.find_by!(slug: params[:id])
  end

  # access helpers within controller
  class Helper
    include Singleton
    include PlaquesHelper
  end

  def streetview_to_params
    return unless params[:streetview_url]

    point = Helper.instance.geolocation_from params[:streetview_url]
    return if point.latitude.blank? || point.longitude.blank?

    params[:area][:latitude] = point.latitude.to_s
    params[:area][:longitude] = point.longitude.to_s
  end

  private

  def permitted_params
    params.require(:area).permit(
      :country_id,
      :latitude,
      :longitude,
      :name,
      :slug,
      :streetview_url
    )
  end
end
