require 'erb'
require 'json'
require 'staging-preseed-server/hosts'

class HostsController
  def self.list
    JSON.generate(Hosts.list)
  end

  def self.get(name)
    return 404 unless Hosts.get(name)
    JSON.generate(Hosts.get(name))
  end

  def self.create(name, params)
    return 409 if Hosts.get(name)
    Hosts.create(name, params)
    201
  end

  def self.delete(name)
    return 404 unless Hosts.get(name)
    Hosts.delete(name)
    204
  end

  def self.preseed(name)
    return 404 unless Hosts.get(name)
    host = Hosts.get(name)
    metadata = host['metadata']
    viewdir = File.expand_path('../../../views', __FILE__)
    ERB.new(File.open("#{viewdir}/#{host['preseed']}").read).result(binding)
  end

  def self.finish(name)
    return 404 unless Hosts.get(name)
    host = Hosts.get(name)
    metadata = host['metadata']
    viewdir = File.expand_path('../../../views', __FILE__)
    ERB.new(File.open("#{viewdir}/#{host['finish']}").read).result(binding)
  end
end
