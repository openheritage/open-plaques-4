# data and actions for open authorisation
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user&.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect @user, event: :authentication
    else
      # docs say to comment this out for prod and it's useful for debugging
      # session['devise.google_data'] = request.env['omniauth.auth']

      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join('\n')
    end
  end
end
