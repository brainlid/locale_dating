$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "locale_dating/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "locale_dating"
  s.version     = LocaleDating::VERSION
  s.authors     = ["Mark Ericksen"]
  s.email       = ["brainlid@gmail.com"]
  s.homepage    = "http://github.com/brainlid/locale_dating"
  s.summary     = "LocalDating does what Rails should be doing. It makes working with dates and times as text
                   in forms painless. It works with your I18n locales to use your desired formats and respects
                   the user's timezone."
  s.description = "LocaleDating generates wrapper methods around the attributes you want to support editing
                   Date, Time, and DateTime values as text using the desired I18n locale format."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1"

  s.add_development_dependency "sqlite3"
end
