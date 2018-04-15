module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      history_var_name = "@#{name}_history".to_sym

      define_method(name) do
        instance_variable_get(var_name)
      end

      define_method("#{name}=") do |value|
        unless instance_variable_get(history_var_name)
          instance_variable_set(history_var_name, [])
        end
        instance_variable_get(history_var_name) << value
        instance_variable_set(var_name, value)
      end

      define_method("#{name}_history") do
        instance_variable_get(history_var_name)
      end
    end
  end

  def strong_attr_acessor(name, type)
    var_name = "@#{name}".to_sym

    define_method(name) do
      instance_variable_get(var_name)
    end

    define_method("#{name}=") do |value|
      raise 'Invalid class' unless value.is_a? type
      instance_variable_set(var_name, value)
    end
  end
end
