# extconf based on http://blog.zachallett.com/howto-ruby-c-extension-with-a-static-library/

require 'mkmf'

LIBDIR     = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']

HEADER_DIRS = [INCLUDEDIR]

# setup constant that is equal to that of the file path that holds that static libraries that will need to be compiled against
LIB_DIRS = [LIBDIR, File.expand_path(File.join(File.dirname(__FILE__), '.'))]

# array of all libraries that the C extension should be compiled against
libs = ['-lkpass', '-lnettle']

dir_config('keepass', HEADER_DIRS, LIB_DIRS)

# iterate though the libs array, and append them to the $LOCAL_LIBS array used for the makefile creation
# link platform specific files to make the process seamless
libs.each do |lib|
  $LOCAL_LIBS << "#{lib} "
end

create_makefile 'keepass'
