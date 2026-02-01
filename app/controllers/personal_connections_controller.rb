require "aws-sdk-comprehend"

# control personal connections
class PersonalConnectionsController < ApplicationController
  before_action :authenticate_admin!, only: :destroy
  before_action :find, only: :destroy
  before_action :find_plaque, only: %i[new create]
  before_action :list_verbs, only: :new

  def destroy
    @personal_connection.destroy
    redirect_back(fallback_location: root_path)
  end

  def new
    @personal_connection = @plaque.personal_connections.new
    suggestions = @personal_connection.suggestions
    @entities = suggestions[1]
    @suggested_people = suggestions[0]
    if params[:person_id]
      @person = Person.find(params[:person_id])
    else
      @person = @suggested_people.first unless @person || @suggested_people.size > 1
    end
    default_verb = @person&.default_action || Verb.find_by(name: "was")
    if default_verb.name == "was" && @plaque.inscription.include?("lived near")
      default_verb = Verb.find_by(name: "lived near")
    elsif default_verb.name == "was" && @plaque.inscription.include?("lived")
      default_verb = Verb.find_by(name: "lived")
    end
    @personal_connection.verb = default_verb
  end

  def create
    params[:personal_connection][:started_at] += "-01-01 00:00:01" if params[:personal_connection][:started_at] =~ /\d{4}/
    params[:personal_connection][:ended_at] += "-01-01 00:00:01" if params[:personal_connection][:ended_at] =~ /\d{4}/
    @personal_connection = @plaque.personal_connections.new
    # whom..
    @personal_connection.person_id = params[:personal_connection][:person_id]
    # did what...
    @personal_connection.verb_id = params[:personal_connection][:verb_id]
    # when...
    @personal_connection.ended_at = params[:personal_connection][:ended_at]
    @personal_connection.started_at = params[:personal_connection][:started_at]
    if @personal_connection.save!
      redirect_back(fallback_location: root_path)
    else
      # can we just redirect to new?
      list_verbs
      render :new
    end
  end

  protected

  def find
    @personal_connection = PersonalConnection.find(params[:id])
  end

  def find_plaque
    @plaque = Plaque.find(params[:plaque_id])
  end

  def list_verbs
    @verbs = Verb.alphabetically.select("id, name")
  end

  private

  def permitted_params
    params.require(:personal_connection).permit(
      :ended_at,
      :person_id,
      :started_at,
      :verb_id
    )
  end
end
