# frozen_string_literal: true

require_relative "lib/active_storage/service/version"

Gem::Specification.new do |spec|
  spec.name = "aliyunoss-activestorage-adapter"
  spec.version = ActiveStorage::AliyunossService::VERSION
  spec.authors = ["yiiecc"]
  spec.email = ["yijiecc@hotmail.com"]

  spec.summary = "A plugin that enables Rails App using Aliyun OSS."
  spec.description = "A plugin that enables Rails App using Aliyun OSS, this gem depends on aliyunoss gem."
  spec.homepage = "https://rubygems.org/gems/aliyunoss-activestorage-adapter"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "https://github.com/yijiecc/activestorage-aliyunoss"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yijiecc/activestorage-aliyunoss"
  spec.metadata["changelog_uri"] = "https://github.com/yijiecc/activestorage-aliyunoss/blob/main/CHANGELOG.md"

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

  spec.add_dependency "aliyunoss", "~> 0.2"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
