require "grade/version"

module Grade
  CONFIG = Yaml.load('config.yml')
end

require 'grade/helpers'
require 'grade/cli'