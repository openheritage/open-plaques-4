# control verbs
class VerbsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @verbs = Verb.order(personal_connections_count: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @verbs }
    end
  end

  def autocomplete
    limit = params[:limit] || 5
    @verbs = "{}"
    q = params[:q]
    if q do
      @verbs = Verb.select(:id, :name).name_starts_with(q).limit(limit)
      @verbs += Verb.select(:id, :name).name_contains(q).limit(limit)
      @verbs.uniq!
    end
    respond_to do |format|
      format.html { render html: @verbs.map { |verb| "<li class=\"list-group-item\" role=\"option\" data-autocomplete-value=\"#{verb.id}\">#{verb.name}</li>" }.join.html_safe }
      format.json { render json: @verbs.as_json(only: %i[id name]) }
    end
  end

  def show
    @verb = Verb.find_by(name: params[:id].tr("_", " "))
    page = permitted_show_params[:page]
    per_page = 50
    @personal_connections = @verb.personal_connections.paginate(page:, per_page:)
    respond_to do |format|
      format.html
      format.json { render json: @verb }
    end
  end

  def new
    @verb = Verb.new
  end

  def create
    @verb = Verb.new(permitted_params)
    if @verb.save
      redirect_to verb_path(@verb)
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:verb).permit(
      :name
    )
  end
end
