# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "workbench"
  s.version     = "0.2"
  s.authors     = ["Tim Harper", "Eric Wollesen", "Ben Mabey"]
  s.email       = ["tim@leadtune.com"]
  s.homepage    = "http://github.com/leadtune/workbench"
  s.summary     = "A small, simple ORM agnostic factory library that does the job without any crazy tricks."
  s.description = <<-EOF
There are a lot of factory frameworks, why one more? In my experience
the otherones use fancy DSLs that were intended to increase
readability but instead increased confusion.

Workbench doesn't use a fancy DSL. It uses ruby. It doesn't use any
fancy tricks like providing proxy objects for modification, workbench
builders operate on the actual model. Since it uses very little
tricks, it is also ORM agnostic. If your models respond to '.new' and
you set attributes by calling #attribute=, then Workbench will work
with your model.

I have a hard time understanding why all the complexity around factory
builders has grown, but often I look at the resulting DSL and say
"That's more work than just defining a method and calling Model.new!"
EOF

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "ruby-debug19"

  s.files        = Dir.glob("{spec,lib}/**/*") + %w(MIT_LICENSE README.rdoc Gemfile)
  s.require_path = 'lib'
end
