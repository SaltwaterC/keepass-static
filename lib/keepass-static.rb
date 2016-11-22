require_relative 'keepass-util'

ver = ruby_version
plat = ruby_platform

require_relative "#{ver[:major]}.#{ver[:minor]}/#{plat[:arch]}/keepass"
require_relative 'keepass-methods'
