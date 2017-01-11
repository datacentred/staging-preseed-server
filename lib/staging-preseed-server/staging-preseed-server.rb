require 'json'
require 'sinatra/base'
require 'staging-preseed-server/hosts-controller'

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
    HostsController.list
  end

  get '/hosts/:host' do
    HostsController.get(params['host'])
  end

  post '/hosts/:host' do
    HostsController.create(params['host'], @body)
  end

  delete '/hosts/:host' do
    HostsController.delete(params['host'])
  end

  get '/hosts/:host/preseed' do
    HostsController.preseed(params['host'])
  end

  get '/hosts/:host/finish' do
    HostsController.finish(params['host'])
  end
end
