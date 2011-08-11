require 'spec_helper'

describe Workbench do
  USER_BUILDER = Module.new do
    extend Workbench

    def user_defaults(u)
      u.name  ||= "Bill"
      u.phone ||= "999-999-9999"
    end
  end

  before(:each) do
    Workbench.reset_counters!
  end

  describe "defining builders" do
    it "creates a module with create_, new_, and find_or_create_" do
      builder_methods = Module.new do
        extend Workbench

        def user_defaults(u)
          u.name ||= "Bill"
          u.phone ||= "999-999-9999"
        end
      end

      methods = builder_methods.instance_methods.map(&:to_sym)
      methods.should include(:new_user)
      methods.should include(:create_user)
      methods.should include(:find_or_create_user)
    end

    it "passes the next counter value to the builder method when arity = 2" do
      builder_methods = Module.new do
        extend Workbench

        def user_defaults(u, n)
          u.name ||= "Bill #{n}"
        end
      end

      extend builder_methods

      new_user.name.should == "Bill 1"
      new_user.name.should == "Bill 2"
    end

    it "passes the overrides hash when arity = 3" do
      builder_methods = Module.new do
        extend Workbench

        def user_defaults(u, n, overrides)
          u.active = true unless overrides.has_key?(:active)
        end
      end

      extend builder_methods
      new_user(:active => false).should_not be_active
    end

    it "passes the overrides hash if arity is < -1 (unfortunately, the value when a splat or default value used)" do
      builder_methods = Module.new do
        extend Workbench

        def user_defaults(u, n = -1, overrides = { })
          u.active = true unless overrides.has_key?(:active)
        end
      end

      extend builder_methods
      new_user(:active => false).should_not be_active
    end
  end

  describe "counting" do
    it "scopes counting to builders with the same class" do
      builder_methods = Module.new do
        extend Workbench

        def user_defaults(u, n)
          u.name ||= "User #{n}"
        end

        use_class :user
        def admin_user_defaults(u, n)
          u.name ||= "Admin #{n}"
          user_defaults(u, n)
        end
      end

      extend builder_methods
      new_user       .name.should == "User 1"
      new_admin_user .name.should == "Admin 2"
      new_user       .name.should == "User 3"
    end

  end

  describe ".count_with" do
    it "causes the counter to count with the provided model" do
      admin_user = Class.new(User)
      builder_methods = Module.new do
        extend Workbench

        def user_defaults(u, n)
          u.name ||= "User #{n}"
        end

        use_class admin_user
        count_with :user
        def admin_user_defaults(u, n)
          u.name ||= "Admin #{n}"
          user_defaults(u, n)
        end
      end
      extend builder_methods
      new_user       .name.should == "User 1"
      new_admin_user .name.should == "Admin 2"
      new_user       .name.should == "User 3"
    end
  end

  describe ".use_class" do
    it "over-rides the class to use for the next defined builder" do
      builder_methods = Module.new do
        extend Workbench

        use_class :User
        def admin_user_defaults(u)
          u.name = "Bill"
          u.phone = "999-999-9999"
        end
      end

      extend builder_methods
      new_admin_user.class.should == User
    end

  end

  describe "#new_(builder_name)" do
    before(:each) do
      extend USER_BUILDER
    end

    it "initializes a model with .new, calls user_defaults, but doesn't call save" do
      user = new_user
      user.name.should  == "Bill"
      user.phone.should == "999-999-9999"
      user.should be_a_new_record
    end

    it 'sets attributes passed as an argument by calling Model#attribute=' do
      user = new_user(:name => "Bob")
      user.name.should == "Bob"
      user.phone.should == "999-999-9999"
    end
  end

  describe "#create_(builder_name)" do
    it "behaves like #new_(builder_name), but calls save at the end" do
      extend USER_BUILDER
      user = create_user(:name => "Bob")
      user.name.should == "Bob"
      user.phone.should == "999-999-9999"
      user.should_not be_a_new_record
      user.name.should == "Bob"
    end
  end

  describe "#find_of_create_(builder_name)" do
    it "calls Model.where(attributes).first. If a model is returned, use that, otherwise, create it" do
      extend USER_BUILDER
      bob_user = create_user(:name => "Bob")
      User.should_receive(:where).with({ :name => "Bob" }).and_return([bob_user])
      find_or_create_user(:name => "Bob").should == bob_user
    end
  end
end
