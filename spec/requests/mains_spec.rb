require 'rails_helper'

RSpec.describe 'mains', type: :request do
  it '#index - user not login' do
    get "/"
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(login_mains_path)
  end

  it '#idnex - user login with source' do
    ApplicationController.any_instance.stub(:user_access_token).and_return('test')
    ApplicationController.any_instance.stub(:user_instagram_code).and_return('test')
    ApplicationController.any_instance.stub(:user_info).and_return('test')
    ApplicationController.any_instance.stub(:check_login)

    stub_request(:get, "https://api.instagram.com/v1/users/self/media/recent/?access_token=test")
    .with(headers: {
      'Accept'=>'*/*',
      'Host'=>'api.instagram.com'
      })
    .to_return(
      :status => 200,
      :body => '{"data": [{"type": ""}]}',
      :headers => {"Content-Type"=> "application/json"}
    )
    get'/'
    expect(response).not_to have_http_status(302)
    expect(response).to have_http_status(200)
    expect(response).to render_template(:index)
    expect(response.body).not_to include "You don't have any instagram photos"
  end

  it '#idnex - user login without source' do
    ApplicationController.any_instance.stub(:user_access_token).and_return('test')
    ApplicationController.any_instance.stub(:user_instagram_code).and_return('test')
    ApplicationController.any_instance.stub(:user_info).and_return('test')
    ApplicationController.any_instance.stub(:check_login)

    stub_request(:get, "https://api.instagram.com/v1/users/self/media/recent/?access_token=test")
    .with(headers: {
      'Accept'=>'*/*',
      'Host'=>'api.instagram.com'
      })
    .to_return(
      :status => 200,
      :body => '{"test": "test"}',
      :headers => {"Content-Type"=> "application/json"}
    )
    get'/'
    expect(response).not_to have_http_status(302)
    expect(response).to have_http_status(200)
    expect(response).to render_template(:index)
    expect(response.body).to include  "You don't have any instagram photos"
  end

  it '#auth_user - user auth success' do
    request_params = {
      client_id: Settings['instagram.client_id'],
      client_secret: Settings['instagram.client_secret'],
      redirect_uri: Settings['instagram.redirect_uri'],
      grant_type: 'authorization_code',
      code: nil
    }
    stub_request(:post, "https://api.instagram.com/oauth/access_token")
    .with(body: request_params,
      headers: {
        'Accept'=>'*/*',
        'Host'=>'api.instagram.com',
      })
    .to_return(
      :status => 200,
      :body => '{"test": "test"}',
      :headers => {"Content-Type"=> "application/json"}
    )

    get '/mains/auth_user'
    expect(response).not_to have_http_status(200)
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(root_path)
  end

  it '#auth_user - user auth failed' do
    get '/mains/auth_user', params: {error: 'error'}
    expect(response).not_to have_http_status(200)
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(root_path)
  end
end