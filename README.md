## About

Ruby bindings to libkpass as static built native extensions. Allows easy usage of [keepass](https://github.com/bumuckl/ruby-keepass) library without having the need to deploy a complete toolchain to build the dependencies.

## The problem

Building the original extension is not an issue with keepass itself. The problem is its spotty support in current distributions for (lib)nettle (the encryption library used to build libkpass) and lack of support for libkpass itself.

The initial implementation used to bundle libnettle.a and libkpass.a for linking Ruby's module to these static libs. However, it still required gcc, make, etc. (the whole shebang) even on targets where having these just for one library is not ideal. They are also fairly large compared to Ruby's native extensions. The only thing that's lost in this process is the potential issues with Ruby ABI. It's still possible to implement another build using this idea to work with multiple minor versions of Ruby.

The next step was to bundle the native Ruby extension by itself and skip the whole drama. Fat gems to the rescue. A Ruby wrapper handles the appropriate extension loading. By itself this project doesn't bring a lot of things except for usability and OS X support for libkpass.

## System requirements

 * Ruby 2.1.x
 * Linux 2.6.x
 * OS X 10.10.x

Ruby 2.1.x is required as I work with Chef. Whatever ChefDK is offering as embedded Ruby, is the only version that's going to be supported. Everything else is extra.

While experiments proved that the extensions by themselves are ABI compatible with Ruby 2.0 and 2.2, there's **no guarantees** that they work as advertised.

Ruby 2.0 and 2.2 requires you to link to the appropriate libruby:

```bash
# Ruby 2.0 example
# it's not recommended to use it like this, but it's possible
sudo ln -s /usr/lib64/libruby.so.2.0 /usr/lib64/libruby.so.2.1
```

Ruby 2.3.x is not ABI compatible with 2.1.x (`undefined symbol: rb_data_object_alloc`).

The Linux extension was built under CentOS 6.7, tested under Centos 7, Ubuntu 14.04, Ubuntu 15.10, and Amazon Linux.

The OS X extension was built under OS X 10.10 (Yosemite), tested under OS X 10.11 (El Capitan).

Please note that OS X, ChefDK, Docker is required for building the extensions from source. The CentOS 6.7 build is handled by a Docker container.
