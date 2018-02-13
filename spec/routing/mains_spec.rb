require 'rails_helper'

RSpec.describe 'mains', type: :routing do
  it '#index' do
    expect(get: '/mains').to route_to('mains#index')
  end

  it '#root' do
    expect(get: '/').to route_to('mains#index')
  end

  it '#login' do
    expect(get: '/mains/login').to route_to('mains#login')
  end

  it '#logout' do
    expect(delete: '/mains/logout').to route_to('mains#logout')
  end

  it '#auth_user' do
    expect(get: '/mains/auth_user').to route_to('mains#auth_user')
  end

end