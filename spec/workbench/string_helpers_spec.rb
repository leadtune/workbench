require 'spec_helper'

module Workbench
  describe StringHelpers do
    describe "#constantize" do
      it "returns a constant several levels deep, beginning from object" do
        StringHelpers.constantize("::Workbench::StringHelpers").should == Workbench::StringHelpers
      end

      it "defaults to root if no preceeding colon is provided" do
        lambda {
          StringHelpers.constantize("StringHelpers")
        }.should raise_error(NameError, /uninitialized constant StringHelpers/)
      end

      it "automatically 'classifies' underscored class names" do
        StringHelpers.constantize("workbench/string_helpers").should == Workbench::StringHelpers
      end

      it "returns the provided modules" do
        StringHelpers.constantize(Workbench).should == Workbench
      end

      it "returns the provided classes " do
        StringHelpers.constantize(Class).should == Class
      end
    end

    describe "#classify" do
      it "transforms 'namespace/model_name' to 'Namespace::ModelName'" do
        StringHelpers.classify('namespace/model_name').should == 'Namespace::ModelName'
      end
    end
  end
end
