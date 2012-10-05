require 'api-acl/base'
require 'api-acl/configuration'
require 'api-acl/control'

module ACL
  def self.configure
    yield @config = Configuration.new
    ACL.config = @config
  end

  def self.config=(config)
    @config = config
  end

  def self.config
    @config ||=Configuration.new
  end
end