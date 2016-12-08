# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'passenger_with_gun/version'

Gem::Specification.new do |spec|
  spec.name          = "passenger_with_gun"
  spec.version       = PassengerWithGun::VERSION
  spec.authors       = ["Suyesh Bhandari"]
  spec.email         = ["suyeshb@gmail.com"]

  spec.summary       = "CLEAR Passenger workers"
  spec.description   = "CLEAR Passenger workers"
  spec.homepage      = "http://github.com"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.com"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe/pkms"
  spec.executables   = spec.files.grep(%r{^exe/pkms}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
