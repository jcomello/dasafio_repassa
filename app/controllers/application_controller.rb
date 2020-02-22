class UnsupportedMediaTypeException < RuntimeError; end
class MissingMediaTypeException < RuntimeError; end

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from UnsupportedMediaTypeException, with: :unsupported_content_type
  rescue_from MissingMediaTypeException, with: :missing_content_type

  before_action :require_content_type_header
  before_action :authenticate

  private

  # before_action
  def require_content_type_header
    if request_require_content_type?
      raise MissingMediaTypeException if request.content_type.blank?
      raise UnsupportedMediaTypeException if request.content_type != 'application/json'
    end
  end

  def authenticate
    raise NotImplementedError
  end

  def unsupported_content_type(exception)
    render(json: { errors: { message: 'Content-Type não suportado' } }, status: 415) and return
  end

  def missing_content_type(exception)
    render(json: { errors: { message: 'Content-Type em branco ou não informado' } }, status: 415) and return
  end

  def request_require_content_type?
    request.post? || request.put? || request.patch? || request.options?
  end
end
