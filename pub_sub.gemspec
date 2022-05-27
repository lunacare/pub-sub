# frozen_string_literal: true

require_relative "lib/pub_sub/version"

Gem::Specification.new do |spec|
  spec.name = "pub_sub"
  spec.version = PubSub::VERSION
  spec.authors = ["Alex Bruns"]
  spec.email = ["alex.h.bruns@gmail.com"]

  spec.summary = "publishing and subscribing"
  spec.description = "publishing and subscribing"
  spec.homepage = "https://github.com/lunacare/pub-sub"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq"
  spec.add_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
end
