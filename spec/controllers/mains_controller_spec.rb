require 'rails_helper'

RSpec.describe MainsController, type: :controller do
  it '#login - user not login' do
    get :login
    expect(response).to have_http_status(200)
    expect(response).to render_template(:login)
  end

  it '#login - user already login' do
    session[:access_token] = 'test'
    get :login
    expect(response).not_to have_http_status(200)
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(root_path)
  end

  it '#logout' do
    delete :logout
    expect(response).to have_http_status(302)
    expect(response).to redirect_to(login_mains_path)
  end
end
