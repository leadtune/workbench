require 'rspec'
require File.expand_path("./lib/workbench.rb")

class User
  attr_accessor :name, :phone, :active

  def save
    @saved = true
  end

  def new_record?
    ! @saved
  end

  alias active? active
end

Rspec.configure do
end
