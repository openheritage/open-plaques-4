# list roles by starting letter
class RolesByIndexController < ApplicationController
  def show
    @index = params[:id][0]
    @roles = Role.indexed(params[:id]).by_popularity
    respond_to do |format|
      format.html { render "roles/by_index/show" }
      format.json { render json: @roles }
    end
  end
end
