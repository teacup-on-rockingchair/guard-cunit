require 'guard'
require 'guard/compat/plugin'
require_relative 'cunit/runner'

module Guard
  # main child class of Guard to nherit guard's behaviour
  class Cunit < Plugin
    # new method that also creates the runner class
    def initialize(options = {})
      super
      @options = {
        all_on_start: true
      }.update(options)
      @runner = Runner.new
    end

    # Called when just `enter` is pressed
    # This method should be principally used for long action
    # like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      passed = @runner.run
      throw :task_has_failed unless passed
    end

    def run_on_change(paths)
      UI.info("Process changes in #{paths}")
      run_all
    end
  end

  #
  # add more behaviour to Guard's DSL to be able to configure executors
  # of all the CUnit's Guard tasks
  #
  class Dsl
    #
    # put default values to task executors
    #
    def initialize
      super
      set_cleaner('make clean')
      cunit_runner("./#{File.basename(Dir.getwd)}_unit")
      set_builder('make 2>&1')
      libdir("#{Dir.getwd}")
      @runner = Cunit::Runner.new
    end

    # dsl call to set cunit test executable
    def cunit_runner(name)
      Cunit::Runner.cfg_runner(name)
    end

    # dsl call to set cunit build command/script, by default make
    def set_builder(name)
      Cunit::Runner.cfg_builder(name)
    end

    # dsl call to set cunit clean command/script, by default 'make clean'
    def set_cleaner(name)
      Cunit::Runner.cfg_cleaner(name)
    end

    # dsl call to set dir, where library under test is generated,
    # by default current dir
    def libdir(name)
      Cunit::Runner.cfg_libdir(File.expand_path(name))
    end
  end
end
