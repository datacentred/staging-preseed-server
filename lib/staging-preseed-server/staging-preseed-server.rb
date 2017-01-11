require 'json'
require 'sinatra/base'

class StagingPreseedServer < Sinatra::Base
  set :port, 8421

  before do
    if request.request_method == 'POST'
      begin
        @body = JSON.parse(request.body.read)
      rescue JSON::ParserError
        halt 500
      end
    end
  end

  get '/hosts' do
  end

  get '/hosts/:host' do
  end

  post '/hosts/:host' do
  end

  delete '/hosts/:host' do
  end

  get '/hosts/:host/preseed' do
  end

  get '/hosts/:host/finish' do
  end
end
