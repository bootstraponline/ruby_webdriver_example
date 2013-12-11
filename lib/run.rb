# -- gems
require 'rubygems'
require 'test_runner' # https://github.com/appium/test_runner
require 'spec' # https://github.com/bootstraponline/spec
require 'page-object' # https://github.com/cheezy/page-object
# --

require_relative 'pages/gym'

# It seems $browser must be global.
$browser = Selenium::WebDriver.for :firefox
$browser.manage.timeouts.implicit_wait = 30 # seconds

# -- helper methods
module Kernel
  def id id
    $browser.find_elements(:id, id).detect { |ele| ele.displayed? }
  end

  def css css
    $browser.find_elements(:css, css).detect { |ele| ele.displayed? }
  end

  def xpath xpath
    $browser.find_elements(:xpath, xpath).detect { |ele| ele.displayed? }
  end

  def link text
    xpath("//a[text()='#{text}']")
  end

  def input input
    xpath("//input[@value='#{input}']")
  end
end
# --

# Expose all classes under the Pages module to minitest
::Pages.constants.each do |class_name|
  Minitest::Spec.class_eval do # limit scope ot Minitest::Spec
    define_method class_name.to_s.downcase do
      ivar = "@#{class_name}"
      instance_var = instance_variable_get ivar
      if instance_var
        instance_var
      else
        instance_variable_set ivar, Pages.const_get(class_name).new($browser)
      end
    end
  end
end

# load test and run it
require_relative 'spec/gym'

Minitest.after_run { $browser.quit if $browser }
Minitest.run_specs