def api_sign_in(admin_user)
  configure_api_headers
  request.env['HTTP_AUTHORIZATION'] = authenticate_with_token(admin_user.token)
end

def configure_api_headers
  request.env['CONTENT_TYPE'] = 'application/json'
  request.env['HTTP_ACCEPT'] = 'application/json'
end

def authenticate_with_token(token)
  ActionController::HttpAuthentication::Token.encode_credentials(token)
end
