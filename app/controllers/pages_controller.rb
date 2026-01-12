# control CMS
class PagesController < ApplicationController
  before_action :authenticate_admin!, only: :destroy
  before_action :authenticate_user!, except: :show
  before_action :find, only: %i[show edit update]
  respond_to :html, :json

  def about
    @organisations_count = Organisation.count
  end

  def show
    respond_with @page
  end

  def index
    @pages = Page.order(:slug)
  end

  def new
    @page = Page.new
  end

  def create
    permitted_params[:author_id] = 2
    puts permitted_params
    @page = Page.new(permitted_params)
    return unless @page.save!

    redirect_to pages_path
  end

  def update
    return unless @page.update(permitted_params)

    redirect_to(action: :show, id: @page.slug)
  end

  protected

  def find
    @page = Page.find(params[:id])
  rescue
    @page = Page.find_by!(slug: params[:id] || params[""])
  end

  private

  def permitted_params
    params.require(:page).permit(
      :author_id,
      :category_list,
      :body,
      :latitude,
      :longitude,
      :max_latitude,
      :max_longitude,
      :min_latitude,
      :min_longitude,
      :name,
      :slug,
      :strapline,
      :tag_list
    )
  end
end
