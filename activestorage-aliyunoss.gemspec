# frozen_string_literal: true

require_relative "lib/active_storage/service/version"

Gem::Specification.new do |spec|
  spec.name = "activestorage-aliyunoss"
  spec.version = ActiveStorage::AliyunossService::VERSION
  spec.authors = ["yiiecc"]
  spec.email = ["yijiecc@hotmail.com"]

  spec.summary = "A plugin that enables Rails App using Aliyun OSS."
  spec.description = "A plugin that enables Rails App using Aliyun OSS, this gem depends on aliyunoss gem."
  spec.homepage = "https://little-farm.me"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://little-farm.me"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://little-farm.me"
  spec.metadata["changelog_uri"] = "https://little-farm.me"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
