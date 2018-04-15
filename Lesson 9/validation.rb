module Validation
  class << self
    def included(base)
      base.extend ClassMethods
      base.include InstanceMethods
    end
  end

  module ClassMethods
    attr_reader :validation_rules

    def validate(name, type, params = nil)
      @validation_rules ||= {}
      @validation_rules[name.to_sym] ||= []
      @validation_rules[name.to_sym] << { type: type, params: params }
    end
  end

  module InstanceMethods
    def validation_rules
      self.class.validation_rules || {}
    end

    def valid?
      validate!
      true
    rescue RuntimeError
      false
    end

    protected

    def validate!
      validation_rules.each do |variable, rules|
        var_value = instance_variable_get("@#{variable}".to_sym)

        rules.each do |rule|
          method_name = "validate_#{rule[:type]}".to_sym
          raise 'Wrong type of validation rule' unless respond_to?(method_name, true)
          send method_name, var_value, rule[:params]
        end
      end
    end

    def validate_presence(variable, *)
      raise 'Variable can\'t be nil or empty string' if (variable.nil? || variable == '')
    end

    def validate_format(variable, pattern)
      raise 'Wrong variable format' if variable !~ pattern
    end

    def validate_type(variable, type)
      raise 'Wrong variable type' unless variable.is_a?(type)
    end
  end
end
