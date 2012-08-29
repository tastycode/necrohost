require 'pry'
module Dependinator
  Error = Class.new(Exception) do
    attr_accessor :original_exception
    def initialize(exception = $!)
      original_exception = exception
      super
    end
  end

  def self.included base
    @base = base
    @base.send :extend, ClassMethods
    @base.dependent = base
  end


  module ClassMethods
    def _base
      @base
    end

    def dependent= base
      @base = base
    end

    def dependencies
      @dependencies ||= {}
    end

    def overwritten_methods
      @overwritten_methods ||= {}
    end

    def requires key, options = {}
      fail Error, "Dependency #{key} requires a block" unless block_given? || options[:as]
      dependencies[key] = options[:as] || lambda { yield }
      overwritten_methods[key] = _base.instance_method key if _base.instance_methods.include? key
      method_name = key.to_sym
      _base.class_eval do
        define_method(method_name, Proc.new do |*args|
          _dependency!(method_name, *args)
        end)
      end
    end
  end

  # instance methods
  def _dependency! key, *args
    dependencies = self.class.dependencies
    fail Error, "Unconfigured Dependency" unless dependencies[key]
    dependency = dependencies[key]
    if dependency.kind_of? Proc
      dependency.call.send key, *args
    elsif [:instance, :class].include? dependency
      if dependency == :instance
        # if we have already replaced this method with our own
        if original_method = self.class.overwritten_methods[key]
          bound = original_method.bind self
          bound.call *args
        else
          self.send key, *args
        end
      elsif dependency == :class
        self.class.send key, *args
      end
    elsif dependency.respond_to? key
      dependency.send key, *args
    else
      fail Error, "Unresolvable dependency #{key} is not compatible class, symbol or proc"
    end
  rescue ArgumentError => e 
    fail Error, "Parameter mismatch for dependency #{key} given args length #{args.length}"
  end
end
