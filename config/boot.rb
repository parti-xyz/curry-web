ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.
require 'dotenv'

powenv_file_path = ".powenv"
if File.exists?(powenv_file_path)
  Dotenv.load(powenv_file_path)
end

env_file_path = "config/env.custom"
if File.exists?(env_file_path)
  Dotenv.load(env_file_path)
end
