require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

unless RUBY_VERSION =~ %r{^1.9}
  require 'coveralls'
  require 'simplecov'
  require 'simplecov-console'

  SimpleCov.formatters = [
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter 'spec/fixtures'
  end
end

RSpec.configure do |c|
  default_facts = {
    puppetversion: Puppet.version,
    facterversion: Facter.version
  }
  default_facts.merge!(YAML.load(File.read(File.expand_path('../default_facts.yml', __FILE__)))) if File.exist?(File.expand_path('../default_facts.yml', __FILE__))
  default_facts.merge!(YAML.load(File.read(File.expand_path('../default_module_facts.yml', __FILE__)))) if File.exist?(File.expand_path('../default_module_facts.yml', __FILE__))
  c.default_facts = default_facts
end

# vim: syntax=ruby
