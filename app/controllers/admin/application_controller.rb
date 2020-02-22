class Admin::ApplicationController < ApplicationController
  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      AdminUser.find_by(token: token)
    end
  end

  def current_admin_user
    @current_admin_user ||= authenticate
  end
end
