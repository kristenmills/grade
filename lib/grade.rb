require "grade/version"
require 'yaml'

module Grade
  CONFIG = YAML.load(File.open('config.yml'))
end

require 'grade/helpers'
require 'grade/cli'