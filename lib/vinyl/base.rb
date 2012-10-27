module Vinyl

  def self.configure
    yield config
  end

  def self.config=(config)
    @config = config
  end

  def self.config
    @config ||=Configuration.new
  end

  def self.check_level(route,method)
    method_routes = Vinyl.acl_routes_collection[method]
    return Vinyl.access_level_with_no_validators if method_routes.nil? || method_routes.empty?
    validators_to_call = method_routes[route]
    return Vinyl.access_level_with_no_validators if validators_to_call.nil?
    if validators_to_call.empty?
      if global_validators.empty?
        return Vinyl.access_level_with_no_validators
      else
        validators_to_call = {1 => []} #No access level defined but global validators must be called
      end
    end
    keys = validators_to_call.keys.sort
    highest_level = 0
    keys.send("#{Vinyl::config.validators_iterate_strategy}") do |access_level|
      pass = Vinyl::Validators.run_validators(validators_to_call[access_level])
      if (pass==true) then
        highest_level = access_level
        break if Vinyl::config.api_acl_mode == Vinyl::Configuration::STRATEGY_DESCENDING #Already on the highest level
      elsif (pass==false)
        break if Vinyl::config.api_acl_mode == Vinyl::Configuration::STRATEGY_ASCENDING #Do not check for higher levels
      end
    end
    return highest_level
  end

  def self.access_level_with_no_validators
    return Vinyl.config.force_access_control ? 0 : 1
  end

  class Configuration

    attr_accessor :api_acl_mode, :force_access_control, :warn_on_missing_validators
    STRATEGY_DESCENDING = 1 #Check for validators starting on the highest access level
    STRATEGY_ASCENDING = 2  #Check for validators starting on the lowest access level

    @@defaults = {
      :api_acl_mode => STRATEGY_DESCENDING,
      :force_access_control => false,
      :warn_on_missing_validators => true
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