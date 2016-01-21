nv = '3.1'
kv = '6'

desc 'Build vendor libraries and native extension'
task :build do
  cflags = ''
  # Linux requires position independent code to link to static libs
  cflags = 'CFLAGS=-fPIC' if Gem::Platform.local.os == 'linux'

  Dir.chdir('build') do
    Dir.chdir('vendor') do
      rm_rf "nettle-#{nv}"
      rm_rf "libkpass-#{kv}"
      system "tar -xf nettle-#{nv}.tar.gz && tar -xf libkpass-#{kv}.tar.gz"

      Dir.chdir("nettle-#{nv}") do
        buildcmd = "#{cflags} ./configure --prefix=\$(pwd) && make install"
        puts "Run buildcmd #{buildcmd}"
        system buildcmd
      end

      Dir.chdir("libkpass-#{kv}") do
        system "patch -p1 < ../libkpass-#{kv}.patch"
        buildcmd = "#{cflags} LDFLAGS=-L../nettle-#{nv} CPPFLAGS=-I../nettle-#{nv}/include ./configure --prefix=\$(pwd) && make install"
        puts "Run buildcmd #{buildcmd}"
        system buildcmd
      end
    end

    cp "vendor/nettle-#{nv}/lib/libnettle.a", '.'
    cp "vendor/libkpass-#{kv}/lib/libkpass.a", '.'

    system 'ruby extconf.rb'
    system 'make'
  end
end

desc 'Remove build artifacts'
task :clean do
  rm_rf "build/vendor/nettle-#{nv}"
  rm_rf "build/vendor/libkpass-#{kv}"
  rm_f 'build/libnettle.a'
  rm_f 'build/libkpass.a'
end
