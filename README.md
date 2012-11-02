# Guard CUnit  [![Build Status](https://secure.travis-ci.org/teacup-on-rockingchair/guard-cunit.png?branch=master)](http://travis-ci.org/teacup-on-rockingchair/guard-cunit)

CUnit Guard allows you to run/watch Unit test for C modules, or anything other that works with Makefile

Soon will add parser for CUnit tests, and probably other UT libs

## Install

Need to have guard and also some of the notifiers that guard uses

otherwise, get the gemfile and install it:
```
$ gem install ./guard-cunit-*.gem
```

will put that in rubygems soon

# Guardfile

Generating the Guardfile is like all the other

```
$ guard init cunit
```

The file by default looks like this:

```
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

#
# Cunit Guardfile - keep dflt builders after guard watcher's block
#
guard 'cunit' do
      watch(%r{((.+)\.c$)|((.+)\.h$)|((M|m)akefile$)} )	
end

set_builder "make 2>&1"
set_cleaner "make clean"
cunit_runner "#{File.basename(Dir.getwd)}_unit"
libdir "#{Dir.getwd}"

```

After the guard block are the new methods from Guardfile DSL, which are used for the tasks needed to be performed on running the build/tests



## Usage

For all other stuff related to guard's usage please read [Guard usage doc](https://github.com/guard/guard#readme)

Testing
-----------

Run rspec in top directory of the project or guard-rspec


Todo
-----------
- fix all bugs :)
- add parser for CUNIT tests
- add hook for coverage
- ... whatever wind blows ...

Author
----------
[A tea cup on a rocking chair](https://github.com/strandjata)

