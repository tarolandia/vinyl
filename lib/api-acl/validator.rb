module ACL
  module Validators
    def self.run_validators(validators)
      validators.concat(ACL::config.global_validators)
      if validators.nil? || validators.empty? then
        return true
      end
      validators.each do |method_name|
        pass = ACL::Validators.send(method_name)
        if(pass == false) then
          return false
        end
      end
      return true
    end

    def self.method_missing(*args) #Return false if no validator exists
      STDOUT.puts "Warning: missing method #{args[0]}, Validator defaults to false"
      return false
    end
  end
end