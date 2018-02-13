require_relative 'spec_helper'

RSpec.describe App do
  it 'get sinatra response' do
    get '/'

    expect(last_response).to be_ok
  end
end
