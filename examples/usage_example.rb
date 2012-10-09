require 'api-acl'
require_relative 'rules_example'

module ACL
  module Validators

    def self.global
      return true
    end

    def self.arbitrary_validator
      return true
    end
  end
end

ACL.configure do |config|
  config.force_access_control = true
  config.global_validators = ['global']
  config.api_acl_mode = ACL::Configuration::STRATEGY_DESCENDING #this is the default value
end

MyRule.new #Use defined validators

access_level = ACL::Control.put({:consumer => ''}).put({:user => ''}).check_level('test','POST')
p access_level