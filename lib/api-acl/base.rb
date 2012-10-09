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

  class Configuration

    attr_accessor :api_acl_file, :api_acl_mode, :force_access_control, :global_validators
    
    @@defaults = {
      :api_acl_file => 'config/api_acl.rb',
      :api_acl_mode => 'default',
      :force_access_control => false,
      :global_validators => Array.new
    }

    def self.defaults
      @@defaults
    end

    def initialize
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end
  end
end
