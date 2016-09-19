ver = RUBY_VERSION.split '.'

require_relative "#{ver[0]}.#{ver[1]}/keepass"
require_relative 'keepass-methods'
