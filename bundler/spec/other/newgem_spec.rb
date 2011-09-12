require "spec_helper"

describe "bundle gem" do
  before :each do
    bundle 'gem test-gem'
  end

  it "generates a gem skeleton" do
    bundled_app("test-gem/test-gem.gemspec").should exist
    bundled_app("test-gem/Gemfile").should exist
    bundled_app("test-gem/Rakefile").should exist
    bundled_app("test-gem/lib/test-gem.rb").should exist
    bundled_app("test-gem/lib/test-gem/version.rb").should exist
  end

  it "starts with version 0.0.1" do
    bundled_app("test-gem/lib/test-gem/version.rb").read.should =~ /VERSION = "0.0.1"/
  end

  it "nests constants so they work" do
    bundled_app("test-gem/lib/test-gem/version.rb").read.should =~ /module Test\n  module Gem/
    bundled_app("test-gem/lib/test-gem.rb").read.should =~ /module Test\n  module Gem/
  end

  it "requires the version file" do
    bundled_app("test-gem/lib/test-gem.rb").read.should =~ /require "test-gem\/version"/
  end

  it "runs rake without problems" do
    system_gems ["rake-0.8.7"]

    rakefile = <<-RAKEFILE
      task :default do
        puts 'SUCCESS'
      end
RAKEFILE
    File.open(bundled_app("test-gem/Rakefile"), 'w') do |file|
      file.puts rakefile
    end

    Dir.chdir(bundled_app("test-gem")) do
      sys_exec("rake")
      out.should include("SUCCESS")
    end
  end
end
