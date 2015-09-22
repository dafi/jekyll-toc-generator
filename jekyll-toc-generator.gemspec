# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "jekyll-toc-generator"
  spec.version       = "0.0.1"
  spec.authors       = ["Ivan Tse", "Matthias Beyer"]
  spec.email         = ["ivan.tse1@gmail.com", "mail@beyermatthias.de"]
  spec.summary       = "Generate TOC from page."
  spec.description   = ""
  spec.homepage      = "https://github.com/matthiasbeyer/jekyll-toc-generator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split.select { |s| s =~ /\.rb$/ }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "jekyll", '~> 2.0'
  spec.add_dependency "nokogiri"
end

