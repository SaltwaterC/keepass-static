require 'rake/testtask'

require_relative 'lib/keepass-util'

nv = '3.2'
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
      sh "tar -xf nettle-#{nv}.tar.gz && tar -xf libkpass-#{kv}.tar.gz"

      Dir.chdir("nettle-#{nv}") do
        buildcmd = "#{buildflags} ./configure --prefix=\$(pwd) && make install"
        puts "Run buildcmd #{buildcmd}"
        sh buildcmd
      end

      Dir.chdir("libkpass-#{kv}") do
        sh "patch -p1 < ../libkpass-#{kv}.patch"
        buildcmd = "#{buildflags} LDFLAGS=-L../nettle-#{nv} "\
          "CPPFLAGS=-I../nettle-#{nv}/include ./configure --prefix=\$(pwd) && "\
          'make install'
        puts "Run buildcmd #{buildcmd}"
        sh buildcmd
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

    sh 'ruby extconf.rb'
    sh 'make'

    if Gem::Platform.local.os == 'linux'
      sh 'strip --strip-unneeded keepass.so'
    end
  end

  Rake::Task['test'].invoke
end

desc 'Build vendor libraries and native extension in Docker container'
task :dockervendor do
  sh "docker build -t keepass-static -f Dockerfile-#{ENV['ver']} ."
  sh 'docker run --name keepass-static keepass-static'
  sh 'docker cp keepass-static:/root/build/keepass.so build/keepass.so'
end

desc 'Copies the built binaries to the correct path'
task :copy do
  ver = ruby_version
  path = "binary/#{ver[:major]}.#{ver[:minor]}"

  mkdir_p 'binary/2.1'
  cp 'build/keepass.bundle', path
  cp 'build/keepass.so', path
end

desc 'Build OS X bundle natively and Linux so in a Docker container'
task :build do
  cp_r 'binary/2.1', 'lib'
  sh 'gem build keepass-static.gemspec'
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
  rm_rf 'lib/2.1'
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
