class Employee::ApplicationController < ApplicationController
  private

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      Employee.find_by(token: token)
    end
  end

  def current_employee
    @current_employee ||= authenticate
  end
end
