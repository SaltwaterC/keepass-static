## About

Ruby bindings to libkpass as static built native extensions. Allows easy usage of [keepass](https://github.com/bumuckl/ruby-keepass) library without having the need to deploy a complete toolchain to build the dependencies.

## The problem

Building the original extension is not an issue with keepass itself. The problem is its spotty support in current distributions for (lib)nettle (the encryption library used to build libkpass) and lack of support for libkpass itself.

The initial implementation used to bundle libnettle.a and libkpass.a for linking Ruby's module to these static libs. However, it still required gcc, make, etc. (the whole shebang) even on targets where having these just for one library is not ideal. They are also fairly large compared to Ruby's native extensions. The only thing that's lost in this process is the potential issues with Ruby ABI. It's still possible to implement another build using this idea to work with multiple minor versions of Ruby.

The next step was to bundle the native Ruby extension by itself and skip the whole drama. Fat gems to the rescue. A Ruby wrapper handles the appropriate extension loading. libgettext support was removed from libkpass to simplify the dependency tree.

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

## How to use

Install the gem under a supported platform.

```ruby
require 'keepass-static'

# functionality specific for upstream extension
kdb = Keepass::Database.new 'database.kdb', 'password' # open KeePass database
kdb = Keepass::Database.open 'database.kdb', 'password' # alias for new

# array listing all the database groups
kdb.groups
# array listing all the database entries
kdb.entries
# array listing all the entries for group with array index idx
kdb.groups[idx].entries

# functionality specific to keepass-static
# return group by name
# no named group returns nil
# on duplicate throw an exception
kdb.group 'name'
# return entry with specified tile
# no named title returns nil
# on duplicate throw an exception
kdb.entry 'title'
# return an entry with specified title from the named group
# missing group or entry returns nil
# on duplicate group or entry throw an exception
kdb.entry 'title', 'name'
```

KeePass itself supports duplicates, but group and entry selector methods throw exceptions on duplicates. If you wish to retain this duplicates behaviour, only use the groups and entries accessors.

## Group and Entry structures

```
#<Keepass::Group:0x007fe813174618
 @atime=2999-12-28 23:59:59 UTC,
 @ctime=2999-12-28 23:59:59 UTC,
 @etime=2999-12-28 23:59:59 UTC,
 @id=-1269572500,
 @kdb=
  #<Keepass::Database:0x007fe813174730
   @kdb=#<Keepass::Database:0x007fe813174668>>,
 @mtime=2999-12-28 23:59:59 UTC,
 @name="name">
```

```
#<Keepass::Entry:0x007fe8131ba780
 @atime=2016-01-22 18:35:22 UTC,
 @ctime=2016-01-20 18:40:58 UTC,
 @data=
  "file attachment binary data",
 @description="file attachment name",
 @etime=2999-12-28 23:59:59 UTC,
 @guid=-1269572500,
 @mtime=2016-01-22 18:35:22 UTC,
 @name="title",
 @notes="entry notes",
 @password="password value",
 @title="title",
 @url="",
 @username="says on the tin",
 @uuid=283959648>
```

For the keepass extension itself, the only new functionality is the possibility to read an entry attachment by exposing the data field. libkpass already had this functionality, but unexposed into the Ruby bindings.
