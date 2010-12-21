# -*- encoding: utf-8 -*-
require File.expand_path("../lib/vidibus/realm/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "vidibus-realm"
  s.version     = Vidibus::Realm::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary = "Basic realm handling for Vidibus applications"
  s.description = "Provides realm accessor for application controller"
  s.homepage = "http://github.com/vidibus/vidibus-realm"
  s.authors = ["Andre Pankratz"]
  s.email = "andre@vidibus.com"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "vidibus-realm"

  s.add_development_dependency "bundler", ">= 1.0.0"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'
end
