class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def permitted_show_params
    params.permit(
      :area_id,
      :country_id,
      :filter,
      :id,
      :page
    )
  end
end
