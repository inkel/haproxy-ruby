# -*- mode: ruby; encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "haproxy/version"

Gem::Specification.new do |s|
  s.name        = "haproxy"
  s.version     = Haproxy::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Leandro López (inkel)"]
  s.email       = ["inkel.ar@gmail.com"]
  s.homepage    = "https://github.com/inkel/haproxy-ruby"
  s.summary     = %q{HAProxy interface for reading statistics or managing servers (requires HAProxy 1.4+)}
  s.description = %q{This gem is intended for use as a HAProxy interface when you need to read statistics or if you like to manage proxies thru Ruby}

  s.rubyforge_project = "haproxy"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
