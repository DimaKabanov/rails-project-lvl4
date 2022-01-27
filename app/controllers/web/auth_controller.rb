# frozen_string_literal: true

class Web::AuthController < Web::ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    auth_user_info = auth[:info]

    user = User.find_or_initialize_by(email: auth_user_info[:email].downcase)
    user.first_name = auth_user_info[:name]

    if user.save
      sign_in user
      redirect_to root_path, notice: t('messages.welcome_user', user: user.email)
    else
      redirect_to new_session_path, notice: t('messages.inсorrect_user')
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end
