require_relative 'keepass-util'

ver = ruby_version

require_relative "#{ver[:major]}.#{ver[:minor]}/keepass"
require_relative 'keepass-methods'
