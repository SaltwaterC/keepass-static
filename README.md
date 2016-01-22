## About

Ruby bindings to libkpass as static built native extensions. Allows easy usage of [keepass](https://github.com/bumuckl/ruby-keepass) library without having the need to deploy a complete toolchain to build the dependencies.

## The problem

Building the original extension is not an issue with keepass itself. The problem is its spotty support in current distributions for (lib)nettle (the encryption library used to build libkpass) and lack of support for libkpass itself.

The initial implementation used to bundle libnettle.a and libkpass.a for linking Ruby's module to these static libs. However, it still required gcc, make, etc. (the whole shebang) even on targets where having these just for one library is not ideal. They are also fairly large compared to Ruby's native extensions. The only thing that's lost in this process is the potential issues with Ruby ABI.

The next step was to bundle the native Ruby extension by itself and skip the whole drama. Fat gems to the rescue. A Ruby wrapper handles the appropriate extension loading. By itself this project doesn't bring a lot of things except for usability and OS X support for libkpass.

## System requirements

 * Ruby 2.1.x
 * Linux 2.6.x
 * OS X 10.10.x

Ruby 2.1.x is required as I'm a DevOps engineer who works with Chef, therefore whatever ChefDK is offering as embedded Ruby, this is what I'm going to use. While experiments proved that the extensions by themselves are ABI compatible with Ruby 2.0 and 2.2, there's no guarantees that they work as advertised.

The Linux extension was built under CentOS 6.7 and it was tested under Centos 7, Ubuntu 14.04, and Amazon Linux.

The OS X extension was built under OS X 10.10 (Yosemite) and tested under OS X 10.11 (El Capitan).

Please note that OS X (and probably ChefDK) is required for building the extensions from source. The CentOS 6.7 build is handled by a Docker container.
