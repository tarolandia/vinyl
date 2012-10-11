module ACL

  def self.add_validator(name,block)
    Validators.module_eval{define_singleton_method(Validators.prefix + name,block)}
  end

  def self.add_global_validator(name,block)
    Validators.module_eval{define_singleton_method(Validators.prefix + name,block)}
    global_validators << name
  end

  def self.execute(name)
    Validators.send(Validators.prefix + name)
  end

  def self.global_validators
    Validators.global_validators
  end

  module Validators
    
    @@prefix = "validator_"#use prefixs to avoid collisions betweeen variables and methods names
    
    def self.prefix
      @@prefix
    end
    
    def self.global_validators
      @@global_validators ||= Array.new
    end

    def self.run_validators(validators)
      validators = validators + ACL.global_validators
      if validators.nil? || validators.empty? then
        return !ACL.config.force_access_control
      end
      validators.each do |method_name|
        pass = ACL::Validators.send(prefix + method_name)
        if(pass == false) then
          return false
        end
      end
      return true
    end

    def self.method_missing(*args) #Return false if no validator exists
      user_variable = ACL::get(args[0])
      if(user_variable.nil?) then
        STDOUT.puts "Warning: missing method #{args[0]}, Validator defaults to false"
        return false
      else
        return user_variable
      end
    end
  end
end
