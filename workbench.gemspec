# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "workbench"
  s.version     = "0.4"
  s.authors     = ["Tim Harper", "Eric Wollesen", "Ben Mabey"]
  s.email       = ["tim@leadtune.com"]
  s.homepage    = "http://github.com/leadtune/workbench"
  s.summary     = "A small, simple ORM agnostic factory library that does the job without any crazy tricks."
  s.description = <<-EOF
Workbench strikes to reach a better balance between easy-to-read
factory builders, ease of use, and robustness.

Workbench doesn't use any fancy tricks. It's code is small and the
average rubyist should have no trouble reading it. It exploits what
ruby provides. Instead of operating on a proxy object, builders
operate on the actual model. It's also ORM agnostic.
EOF

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rspec", "~> 2.6"
  s.add_development_dependency "ruby-debug19"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc", "3.8"

  s.files        = Dir.glob("{spec,lib}/**/*") + %w(MIT_LICENSE README.rdoc Gemfile)
  s.require_path = 'lib'
end
