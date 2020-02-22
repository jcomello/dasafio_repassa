def api_sign_in(resource)
  configure_api_headers
  request.env['HTTP_AUTHORIZATION'] = authenticate_with_token(resource.token)
end

def configure_api_headers
  request.env['CONTENT_TYPE'] = 'application/json'
  request.env['HTTP_ACCEPT'] = 'application/json'
end

def authenticate_with_token(token)
  ActionController::HttpAuthentication::Token.encode_credentials(token)
end
