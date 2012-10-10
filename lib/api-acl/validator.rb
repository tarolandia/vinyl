module ACL

  def self.add_validator(name,block)
    Validators.module_eval{define_singleton_method(name,block)}
  end

  def self.execute(name)
    Validators.send(name)
  end

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