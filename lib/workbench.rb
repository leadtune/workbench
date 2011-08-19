require File.expand_path('../workbench/string_helpers', __FILE__)
module Workbench
  COUNTERS = Hash.new(0)

  # Declare that the next builder method is to use the said class
  #
  #   module Builders
  #     extend Workbench
  #
  #     def user_defaults(u)
  #       ...
  #     end
  #
  #     use_class :User
  #     def admin_user_defaults(u)
  #       ...
  #     end
  #   end
  #
  # === Parameters:
  #
  # name:: - Symbol such as :User or string such as "Models::User" are
  #          acceptable
  def use_class(name)
    @next_class = name
  end

  # Declare that the next builder method is to count scoped to the following class
  #
  #   module Builders
  #     extend Workbench
  #
  #     def book_defaults(u, n)
  #       ...
  #     end
  #
  #     count_with :Book
  #     def article_defaults(u, n)
  #       ...
  #     end
  #   end
  #
  #   new_book        # n = 1
  #   new_publication # n = 2
  #   new_book        # n = 3
  #
  # === Parameters:
  #
  # +name+:: - a Symbol (ie :User) or string (is "Models::User") that
  #            maps to a valid class name.
  def count_with(name)
    @next_count_with = name
  end

  # The counter routine. Provide a key, get back an incrementer.
  def self.counter(key)
    COUNTERS[key] += 1
  end

  # Reset all counters. It doesn't happen automatically, you'll likley
  # want to call this method before or after each test is run
  def self.reset_counters!
    COUNTERS.clear
  end

private
  def method_added(name)
    if builder_name = inferred_builder_class_name(name)
      klass         = StringHelpers.constantize(@next_class || builder_name)
      counter_klass = StringHelpers.constantize(@next_count_with || klass)
      define_builder_methods(builder_name, klass, counter_klass)
      @next_class, @next_count_with = nil
    end
    super
  end

  def define_builder_methods(name, klass, counter_klass)
    define_method("new_#{name}") do |*args|
      attributes = args[0] || { }
      klass.new.tap do |model|
        attributes.each do |k, v|
          model.send("#{k}=", v)
        end
        build_method = method("#{name}_defaults")
        p = [model]
        p << Workbench.counter(counter_klass) if build_method.arity >= 2 || build_method.arity <= -1
        p << attributes                       if build_method.arity >= 3 || build_method.arity <= -1
        build_method.call *p
      end
    end

    define_method("create_#{name}") do |*args|
      send("new_#{name}", *args).tap do |model|
        if model.respond_to?(:save!) # save should raise if unsuccessful
          model.save!
        else
          model.save
        end
      end
    end

    define_method("find_or_create_#{name}") do |*args|
      attrs = args[0] || { }
      klass.where(attrs).first || send("create_#{name}", attrs)
    end
  end

  def inferred_builder_class_name(name)
    if name.to_s.match(/^(.+)_defaults$/)
      $1.to_sym
    end
  end

end
