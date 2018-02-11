class MainsController < ApplicationController
  before_action :check_login, only: :index

  def index
    # get instagram photos
    begin 
      url = "https://api.instagram.com/v1/users/self/media/recent/?access_token=#{user_access_token}"
      res = RestClient.get url
      render json: res
      return
    rescue RestClient::ExceptionWithResponse => err
      err_response = err.response
      # If access_token expired
      if err_response['meta']['error_type'] == 'OAuthAccessTokenException'
        redirect_to login_mains_path
      end
    end  
  end

  def login
    redirect_to root_path if user_access_token.present?
    @client_id = Settings['instagram.client_id']
    @redirect_uri =  Settings['instagram.redirect_uri']
  end

  def auth_user
    # auth instagram login callbok
    if params['error'] || params['error_type']
      # log failed 
      puts params['error']
    else
      # sotre code in session
      session[:instagram_code] = params['code']
      # get user access_token and user_info
      url = "https://api.instagram.com/oauth/access_token"
      request_params = {
        client_id: Settings['instagram.client_id'],
        client_secret: Settings['instagram.client_secret'],
        redirect_uri: Settings['instagram.redirect_uri'],
        grant_type: 'authorization_code',
        code: params['code']
      }
      
      begin
        response = JSON.parse(RestClient.post url, request_params)
        # store necessary info in session
        session[:access_token] = response['access_token']
        session[:user_info] = response['user']
      rescue RestClient::ExceptionWithResponse => err
        # auth failed 
        puts err
      end
    end  
    redirect_to root_path
  end
end
