# control subjects
class PeopleController < ApplicationController
  before_action :authenticate_admin!, only: :destroy
  before_action :authenticate_user!, except: %i[autocomplete index show update]
  before_action :find, only: %i[edit update destroy geolocate]

  def index
    respond_to do |format|
      format.html do
        if params[:filter] && params[:filter] != ""
          begin
            @people = Person.send(params[:filter].to_s).paginate(page: permitted_show_params[:page], per_page: 50)
            @display = params[:filter].to_s
          rescue # an unrecognised filter method
            redirect_to(controller: :people_by_index, action: :show, id: :a)
          end
        else
          redirect_to(controller: :people_by_index, action: :show, id: :a)
        end
      end
      format.csv do
        @people = Person.with_counts.all
        send_data(
          "\uFEFF#{PersonCsv.new(@people).build}",
          type: "text/csv",
          filename: "open-plaques-subjects-all-#{Date.today}.csv",
          disposition: "attachment"
        ) and return
      end
    end
  end

  def autocomplete
    limit = params[:limit] || 5
    @people = "{}"
    q = params[:q]
    if q
      @people = Person.select(:born_on, :died_on, :gender, :id, :name)
                      .includes(:roles)
                      .name_is(q)
                      .limit(limit)
      @people += Person.select(:born_on, :died_on, :gender, :id, :name)
                       .includes(:roles)
                       .name_starts_with(q)
                       .alphabetically
                       .limit(limit)
      @people += Person.select(:born_on, :died_on, :gender, :id, :name)
                       .includes(:roles)
                       .name_contains(q)
                       .alphabetically
                       .limit(limit)
      @people += Person.select(:born_on, :died_on, :gender, :id, :name)
                       .includes(:roles)
                       .aka(q)
                       .alphabetically
                       .limit(limit)
      @people.uniq!
    end
    respond_to do |format|
      format.html { render html: @people.map { |person| person_partial(person) }.join.html_safe }
      format.json { render json: @people.as_json(methods: %i[action_id name_and_dates primary_role_name type], only: %i[id name]) }
    end
  end

  def person_partial(person)
    <<~HTML
      <li class="list-group-item d-flex justify-content-left align-items-start" role="option" data-autocomplete-value="#{person.id}">
        <div class="avatar avatar-s border border-white rounded-pill">
        #{ ActionController::Base.helpers.image_tag(person.main_photo.thumbnail_url, class: 'rounded-circle', style: "height: 100px;") if person.main_photo&.thumbnail_url }
        </div>
        #{ person.name_and_dates }
        #{ person.primary_role&.role&.name }
      </li>
    HTML
  end

  def geolocate
    @person.geolocate!
    redirect_back(fallback_location: root_path)
  end

  def show
    unless params[:id] =~ /\A\d+\Z/
      redirect_to(controller: :people, action: :index, filter: params[:id]) and return
    end

    @person = Person.with_counts.find(params[:id])
    begin
      set_meta_tags description: "#{@person.name_and_dates} historical plaques and markers"
      set_meta_tags open_graph: {
        type: :website,
        url: url_for(only_path: false),
        image: @person.main_photo ? @person.main_photo.file_url : view_context.root_url[0...-1] + view_context.image_path("openplaques-icon.png"),
        title: "#{@person.name_and_dates} historical plaques and markers",
        description: @person.name_and_dates
      }
      set_meta_tags twitter: {
        card: "summary_large_image",
        site: "@openplaques",
        title: "#{@person.name_and_dates} historical plaques and markers",
        image: {
          _: @person.main_photo ? @person.main_photo.file_url : view_context.root_url[0...-1] + view_context.image_path("openplaques-icon.png"),
          width: 100,
          height: 100
        }
      }
    rescue
    end
    respond_to do |format|
      format.html { @plaques = @person.plaques }
      format.json { render json: @person }
      format.geojson { render geojson: @person }
      format.csv do
        @people = []
        @people << @person
        send_data(
          "\uFEFF#{PersonCsv.new(@people).build}",
          type: "text/csv",
          filename: "open-plaque-subject-#{@person.id}.csv",
          disposition: "attachment"
        )
      end
    end
  end

  def new
    @plaque = Plaque.find(params[:plaque_id]) if params[:plaque_id]
    @person = Person.new
    respond_to do |format|
      format.html
      format.xml { render xml: @person }
    end
  end

  def edit
    @roles = Role.alphabetically
    @personal_role = PersonalRole.new
  end

  def create
    @plaque = Plaque.find(params[:plaque_id]) if params[:plaque_id]
    params[:person][:born_on] += "-01-01" if params[:person][:born_on] =~ /\d{4}/
    params[:person][:died_on] += "-01-01" if params[:person][:died_on] =~ /\d{4}/
    @person = Person.new(permitted_params)
    @person.sex
    respond_to do |format|
      if @person.save
        if params[:role_id] && !params[:role_id].blank?
          @personal_role = PersonalRole.new(person_id: @person.id, role_id: params[:role_id], primary: true)
          @personal_role.save!
          # reget the person now that they have a role
          @person = Person.find @person.id
          @person.sex
          @person.save
        end
        flash[:notice] = "Person was successfully created."
        format.html do
          @roles = Role.alphabetically
          @personal_role = PersonalRole.new
          if @plaque
            redirect_to new_plaque_connection_path(@plaque, person_id: @person)
          else
            redirect_to person_path(@person)
          end
        end
      else
        format.html { render :new }
      end
    end
  end

  def update
    params[:person][:born_on] += "-01-01" if params[:person][:born_on] =~ /\d{4}/
    params[:person][:died_on] += "-01-01" if params[:person][:died_on] =~ /\d{4}/
    respond_to do |format|
      if @person.update(permitted_params)
        flash[:notice] = "Person was successfully updated."
        format.html { redirect_to(@person) }
        format.xml  { head :ok }
      else
        format.html { render :edit }
        format.xml  { render xml: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end

  protected

  def find
    @person = Person.find(params[:id])
  end

  private

  def aka_to_a
    cords = params.dig(:person, :aka).presence || "[]"
    JSON.parse cords
  end

  def permitted_params
    params.require(:person).permit(
      :ancestry_id,
      :aka,
      :born_on,
      :citation,
      :dbpedia_uri,
      :died_on,
      :ethnicity,
      :find_a_grave_id,
      :gender,
      :introduction,
      :latitude,
      :longitude,
      :max_latitude,
      :max_longitude,
      :min_latitude,
      :min_longitude,
      :name,
      :surname_starts_with,
      :wikidata_id,
      :wikipedia_paras,
      :wikipedia_url
    ).merge({ aka: aka_to_a })
  end
end
