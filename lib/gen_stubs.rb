# ruby gen_stubs
require 'rubygems'
require 'parser/current'

f = File.expand_path '../pages/gym.rb', __FILE__

class ProcessPageObjects < Parser::AST::Processor

  attr_reader :name_type_pairs

  def initialize
    @name_type_pairs = []
    super
  end

  # page-object/lib/page-object/elements/*.rb plus page_url
  @@valid_elements = %w[area audio button canvas check_box div element file_field form heading hidden_field image 
label link list_item media option ordered_list paragraph radio_button select_list span table 
table_cell table_row text_area text_field unordered_list video] + %w[page_url]

  def is_valid child
    # child may be a symbol or a string
    @@valid_elements.include?(child.to_s)
  end

  def _print_children children_array
    # `def on_send` receives AST::Node send
    # the children array of that node is sent to _print_children
    # -> symbol :page_url
    # inside print children, the element type is found (page_url)
    # -> AST::Node str/symbol
    # once we know the type, we look for an AST::Node that contains the element name

    pair = []

    find_element_name = false
    element_name = nil # symbol or string
    children_array.each do |child|
      if find_element_name && child.is_a?(AST::Node)
        first = child.children.first
        if first.class == Symbol || first.class == String
          element_name = first.to_s
          # puts "element_name: #{element_name}"
          pair << element_name
          break
        end
      end

      if is_valid child
        # puts "element_type: #{child}"
        pair << child.to_s # element_type
        find_element_name = true
      end unless find_element_name
    end

    @name_type_pairs << pair if pair.length == 2
  end

  def generate_send node
    c = node.children

    return unless c
    _print_children c
    # node.type is send
    # the rest of the data is in the children.
  end

  def on_send node
    generate_send node
    super
  end
end

ast = Parser::CurrentRuby.parse File.read f
page_objects = ProcessPageObjects.new

page_objects.process ast

file_name = File.basename(f, '.*')
output_prefix = <<R
module Stub
  module #{file_name.capitalize}
    class << self
R
output = ''

def wrap str
  ' ' * 6 + str + "\n"
end

page_objects.name_type_pairs.each do |pair|
    element_type = pair.first
    if element_type == 'page_url'
      output += wrap 'def goto; end'
      next
    end

    element_name = pair.last

    output += wrap "def #{element_name}; end"
    output += wrap "def #{element_name}_element; end"
    output += wrap "def #{element_name}?; end"

    output += wrap "def #{element_name}= *txt; txt end" if element_type == 'text_field'
end

stub_file = File.join(File.dirname(f), file_name + '_stub.rb')

output_postfix = <<R
    end
  end
end

module Kernel
  def #{file_name.downcase}
    Stub::#{file_name.capitalize}
  end
end unless Kernel.respond_to? :#{file_name.downcase}
R

output = output_prefix + output + output_postfix

File.open(stub_file, 'w') do |file|
  file.write output.strip
end

# if 'page_url' exists, then we need `def goto`
# for all others, we need the name of the element to generate the remaining methods.

=begin
    (send nil :page_url
      (str "http://www.thegymnasium.com/"))

      page_url 'http://www.thegymnasium.com/'

    # ---

    (send nil :button
      (sym :sign_in)
      (hash
        (pair
          (sym :xpath)
          (str "//*[@id=\"drop001\"]"))))

    button :sign_in, xpath: '//*[@id="drop001"]'

    # ---

    (send nil :text_field
      (sym :user_name)
      (hash
        (pair
          (sym :id)
          (str "user_name"))))

    text_field :user_name, :id => 'user_name'

    # ---

    (send nil :text_field
      (sym :password)
      (hash
        (pair
          (sym :css)
          (str "#loginfrm > fieldset > div.col > #user_pass"))))
    
    text_field :password, :css => '#loginfrm > fieldset > div.col > #user_pass'

    # ---

    (send nil :button
      (sym :submit_sign_in)
      (hash
        (pair
          (sym :css)
          (str "#loginfrm > fieldset > div.btn-holder > input.btn"))))))]

    button :submit_sign_in, css: '#loginfrm > fieldset > div.btn-holder > input.btn'
=end