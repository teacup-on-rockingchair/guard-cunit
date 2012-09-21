require 'guard'
require 'guard/guard'
require "guard/cunit/version"


module Guard
  class Cunit < Guard 
    @@cunit_runner=''
    @@project_builder=''
    @@project_cleaner=''
    @@project_libdir=''
    def initialize(watchers = [], options = {})
      super
      @options = {
        :all_on_start   => true,
      }.update(options)
    end
    
    # set the executable file name to run CUNIT tests
    def Cunit.set_runner(name)
      @@cunit_runner=name
    end
    
    # set command to run to prepare build
    def Cunit.set_builder(name)
      @@project_builder=name
    end

    # set cleaner script/exe/command
    def Cunit.set_cleaner(name)
      @@project_cleaner=name
    end


    # set directory where library under test is generated
    def Cunit.set_libdir(name)
      @@project_libdir=name
    end
    #
    # run one phase of the guard via a system command/executable
    #
    def run_task(task_executable)
      output = String.new
      IO.popen(task_executable)  do |myio|
        output = myio.read
      end
      throw :task_has_failed unless $?.exitstatus == 0
#      puts output
    end

    # run clean before each run all start with clean
    def run_clean
      run_task(@@project_cleaner)
    end
    
    # run unit tests via cunit executable
    def run_tests
      # setup environment so it should include lib dir for ld path
      ENV["LD_LIBRARY_PATH"]="#{ENV["LD_LIBRARY_PATH"]}:#{@@project_libdir}"
      run_task(@@cunit_runner)
    end
    
    
    # run make command to build the project
    def run_make
      run_task(@@project_builder)
    end
    
    # Called when just `enter` is pressed
    # This method should be principally used for long action like running all specs/tests/...
    # @raise [:task_has_failed] when run_all has failed
    def run_all
      run_clean
      run_make
      run_tests
    end
  end

  class Dsl
    def initialize
      super
      set_cleaner("make clean")
      cunit_runner("#{File.basename(Dir.getwd)}_unit")
      set_builder("make 2>&1")
      libdir("#{Dir.getwd}")
    end

    # dsl call to set cunit test executable
    def cunit_runner (name)
      Cunit.set_runner(name)
    end
    
    # dsl call to set cunit build command/script, by default make
    def set_builder (name)
      Cunit.set_builder(name)
    end
    
    #dsl call to set cunit clean command/script, by default 'make clean'
    def set_cleaner (name)
      Cunit.set_cleaner(name)
    end
    
    # dsl call to set dir, where library under test is generated, by default current dir
    def libdir(name)
      Cunit.set_libdir(File.absolute_path(name))
    end

  end
  
end
