class Hosts
  @@hosts = {}

  def self.list
    @@hosts
  end

  def self.get(name)
    @@hosts[name]
  end

  def self.create(name, params)
    @@hosts[name] = params
  end

  def self.delete(name)
    @@hosts.delete(name)
  end
end
