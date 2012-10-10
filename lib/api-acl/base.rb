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

    attr_accessor :api_acl_mode, :force_access_control, :global_validators
    STRATEGY_DESCENDING = 1
    STRATEGY_ASCENDING = 2

    @@defaults = {
      :api_acl_mode => STRATEGY_DESCENDING,
      :force_access_control => false,
      :global_validators => Array.new
    }

    def validators_iterate_strategy
      if(@api_acl_mode == STRATEGY_DESCENDING) then
        return 'reverse_each'
      else
        return 'each'
      end
    end

    def self.defaults
      @@defaults
    end

    def initialize
      @@defaults.each_pair{|k,v| self.send("#{k}=",v)}
    end
  end
end
