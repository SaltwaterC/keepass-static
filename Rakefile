require 'rake/testtask'

nv = '3.1'
kv = '6'

desc 'Build vendor libraries and native extension'
task :vendor do
  buildflags = ''
  # Linux requires position independent code to link to static libs
  # undefined symbol: rpl_malloc is another issue
  if Gem::Platform.local.os == 'linux'
    buildflags = 'CFLAGS=-fPIC ac_cv_func_malloc_0_nonnull=yes'
  end

  Dir.chdir('build') do
    Dir.chdir('vendor') do
      rm_rf "nettle-#{nv}"
      rm_rf "libkpass-#{kv}"
      system "tar -xf nettle-#{nv}.tar.gz && tar -xf libkpass-#{kv}.tar.gz"

      Dir.chdir("nettle-#{nv}") do
        buildcmd = "#{buildflags} ./configure --prefix=\$(pwd) && make install"
        puts "Run buildcmd #{buildcmd}"
        system buildcmd
      end

      Dir.chdir("libkpass-#{kv}") do
        system "patch -p1 < ../libkpass-#{kv}.patch"
        buildcmd = "#{buildflags} LDFLAGS=-L../nettle-#{nv} "\
          "CPPFLAGS=-I../nettle-#{nv}/include ./configure --prefix=\$(pwd) && "\
          'make install'
        puts "Run buildcmd #{buildcmd}"
        system buildcmd
      end
    end

    if File.exist?("vendor/nettle-#{nv}/lib/libnettle.a")
      cp "vendor/nettle-#{nv}/lib/libnettle.a", '.'
    elsif File.exist?("vendor/nettle-#{nv}/lib64/libnettle.a")
      cp "vendor/nettle-#{nv}/lib64/libnettle.a", '.'
    else
      fail "Unable to find vendor/nettle-#{nv}/lib/libnettle.a"
    end

    cp "vendor/libkpass-#{kv}/lib/libkpass.a", '.'

    system 'ruby extconf.rb'
    system 'make'

    if Gem::Platform.local.os == 'linux'
      system 'strip --strip-unneeded keepass.so'
    end
  end

  Rake::Task['test'].invoke
end

desc 'Build OS X bundle natively and Linux so in a Docker container'
task :build do
  bundle_name = 'lib/keepass.bundle'
  so_name = 'lib/keepass.so'

  Rake::Task['vendor'].invoke unless File.exist?(bundle_name)
  mv('build/keepass.bundle', bundle_name) unless File.exist?(bundle_name)

  unless File.exist?(so_name)
    system 'docker build -t keepass-static .'
    system 'docker run --name keepass-static keepass-static'
    system 'docker cp keepass-static:/root/build/keepass.so .'
    mv 'keepass.so', so_name
  end

  system 'gem build keepass-static.gemspec'
end

desc 'Remove temporary build files'
task :clean do
  rm_rf "build/vendor/nettle-#{nv}"
  rm_rf "build/vendor/libkpass-#{kv}"
  rm_f 'build/libnettle.a'
  rm_f 'build/libkpass.a'
  rm_f 'build/Makefile'
  rm_f 'build/keepass.o'
  rm_f 'build/keepass.bundle'
  rm_f 'build/keepass.so'
  rm_f Dir.glob 'keepass-static-*.gem'
  if Gem::Platform.local.os == 'darwin'
    system 'docker rm keepass-static; docker rmi keepass-static'
  end
end

desc 'Remove build artifacts and temporary files'
task cleanall: [:clean] do
  rm_f 'lib/keepass.bundle'
  rm_f 'lib/keepass.so'
end

Rake::TestTask.new do |t|
  t.libs       = %w(build lib)
  t.test_files = Dir.glob('test/*.rb')
end

begin
  # Rubocop stuff
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  STDERR.puts 'Rubocop, or one of its dependencies, is not available.'
end

desc 'Runs all testing tools'
task testall: [:test, :rubocop]
