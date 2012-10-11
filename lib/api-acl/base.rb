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

  def self.check_level(route,method)
    required_route = ACL::acl_routes_collection[route]
    required_route = Hash.new if required_route.nil?
    validators_to_call = required_route[method]
    if (validators_to_call.nil? || validators_to_call.empty?) then
      if (global_validators.empty?) then
        return ACL.config.force_access_control ? 0 : 1
      else
        validators_to_call = {1 => []} #No access level defined but global validators must be called
      end
    end
    keys = validators_to_call.keys.sort
    highest_level = 0
    keys.send("#{ACL::config.validators_iterate_strategy}") do |access_level|
      pass = ACL::Validators.run_validators(validators_to_call[access_level])
      if (pass==true) then
        highest_level = access_level
        break if ACL::config.api_acl_mode == ACL::Configuration::STRATEGY_DESCENDING #Already on the highest level
      elsif (pass==false)
        break if ACL::config.api_acl_mode == ACL::Configuration::STRATEGY_ASCENDING #Do not check for higher levels
      end
    end
    return highest_level
  end

  class Configuration

    attr_accessor :api_acl_mode, :force_access_control
    STRATEGY_DESCENDING = 1 #Check for validators starting on the highest access level
    STRATEGY_ASCENDING = 2  #Check for validators starting on the lowest access level

    @@defaults = {
      :api_acl_mode => STRATEGY_DESCENDING,
      :force_access_control => false
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