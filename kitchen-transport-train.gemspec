lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require "kitchen-transport-train/version"

Gem::Specification.new do |spec|
  spec.name        = "kitchen-transport-train"
  spec.version     = KitchenTransportTrain::VERSION
  spec.licenses    = ["Apache-2.0"]

  spec.summary     = "Kitchen transport for any Train backend"
  spec.description = "Use the Train transport ecosystem for all your Kitchen needs"
  spec.authors     = ["Thomas Heinen"]
  spec.email       = ["theinen@tecracer.de"]
  spec.homepage    = "https://github.com/tecracer-chef/kitchen-transport-train"

  spec.files       = Dir["lib/**/**/**"]
  spec.files      += ["README.md", "CHANGELOG.md"]

  spec.required_ruby_version = ">= 2.6"

  spec.add_dependency "train", ">= 3.5"
end
