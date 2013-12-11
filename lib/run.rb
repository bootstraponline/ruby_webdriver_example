# -- gems
require 'rubygems'
require 'test_runner' # https://github.com/appium/test_runner
require 'spec' # https://github.com/bootstraponline/spec
# --

# It seems $browser must be global.
$driver = Selenium::WebDriver.for :firefox
$driver.manage.timeouts.implicit_wait = 30 # seconds

# -- helper methods
module Kernel
  def id id
    $driver.find_elements(:id, id).detect { |ele| ele.displayed? }
  end

  def css css
    $driver.find_elements(:css, css).detect { |ele| ele.displayed? }
  end

  def xpath xpath
    $driver.find_elements(:xpath, xpath).detect { |ele| ele.displayed? }
  end

  def link text
    xpath("//a[text()='#{text}']")
  end

  def input input
    xpath("//input[@value='#{input}']")
  end
end
# --

# load page objects
require_relative 'pages/gym'

# Expose all classes under the Pages module to minitest & Kernel
::Pages.constants.each do |class_name|
  Minitest::Spec.class_eval do
    puts "Defining method: #{class_name.to_s.downcase}"
    define_method class_name.to_s.downcase do
      Pages.const_get(class_name)
    end
  end

  Kernel.send(:define_singleton_method, class_name.to_s.downcase) do
    Pages.const_get(class_name)
  end
end

# load test
require_relative 'spec/gym'

# run test
Minitest.after_run { $driver.quit if $driver }
Minitest.run_specs