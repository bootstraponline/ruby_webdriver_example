# -- gems
require 'rubygems'
require 'selenium-webdriver'
require 'spec' # https://github.com/bootstraponline/spec
require 'page-object'
# --

# It seems $driver must be global.
$driver = Selenium::WebDriver.for :firefox
$driver.manage.timeouts.implicit_wait = 30 # seconds

# load page objects
require_relative 'pages/gym'

$pages_gym_obj = Pages::Gym.new $driver

module Kernel
  def gym
    $pages_gym_obj
  end
end

# load test
require_relative 'spec/gym'

Minitest.after_run { $driver.quit if $driver }

def run_tests
  # run test
  trace_files = []

  base_path = File.dirname(__FILE__)
  spec_path = File.join(base_path, 'spec/**/*.rb')
  pages_path = File.join(base_path, 'pages/**/*.rb')
  Dir.glob(spec_path) do |f|
    trace_files << File.expand_path(f)
  end
  Dir.glob(pages_path) do |f|
    trace_files << File.expand_path(f)
  end

  Minitest.run_specs ({trace: trace_files})
end

run_tests