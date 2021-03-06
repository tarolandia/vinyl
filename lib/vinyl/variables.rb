module Vinyl

  def self.put(variable)
    controller.put(variable)
    return self
  end

  def self.get(value)
    controller.variables[value]
  end

  def self.reset_variables
    controller.variables.clear
  end

  def self.controller
    @@user_variables ||=UserVariables.new
  end

  def self.method_missing(*args)
    if args.length == 2 then #set value
      Vinyl::put ({args[0].to_s.chomp('=').to_sym => args[1]})
    elsif args.length == 1 #return value
      return Vinyl::get(args.first)
    else
      super
    end
  end

  class UserVariables
    attr_reader :variables

    def initialize
      @variables = Hash.new 
    end

    def put(variable)
      @variables.merge!(variable)
    end
  end
end