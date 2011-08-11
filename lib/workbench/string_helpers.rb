module Workbench
  # A collection of needed String methods. They are here to remove a dependency on ActiveSupport. You can use them if you want... but you probably should use ActiveSupport or copy them into your project.
  module StringHelpers
    # takes :User, "user", or :user and returns User
    def self.constantize(value)
      return value if value.is_a?(Module)
      value = value.to_s
      value = classify(value) unless value =~ /^[A-Z]/
      value = "::#{value}" unless value =~ /^:/
      eval(value.to_s)
    end

    # "transforms 'namespace/model_name' to 'Namespace::ModelName'"
    def self.classify(string)
      string.to_s.gsub("/", "::").gsub(/(_|\b)(.)/) { |r| r[-1..-1].upcase }
    end
  end
end
