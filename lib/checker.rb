require 'colorize'
require 'digest/md5'
require 'erb'

require 'checker/core_ext'
require 'checker/rvm'
require 'checker/version'
require 'checker/installator'
require 'checker/helper'
require 'checker/options'
require 'checker/result'

%w[base multifile ruby haml slim pry coffeescript javascript sass yaml conflict console_log rubocop].each do |mod|
  require "checker/modules/#{mod}"
end

%w[default console_log javascript rubocop].each do |res|
  require "checker/results/#{res}"
end

def debug_mode?
  ENV['CHECKER_DEBUG'].to_s == "1"
end

if debug_mode?
  puts "Running checker with debug mode!".colorize(:yellow)
end

def debug(msg)
  puts "[DEBUG] - #{msg}".colorize(:yellow) if debug_mode?
end

