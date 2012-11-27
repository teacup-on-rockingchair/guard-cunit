require 'guard/cunit/cunit_parser'


module Guard
  class Cunit
#
# the class implements running and handling of results of the tasks that made up the cunit guard
# 
   class Runner
     @@cunit_runner=''
     @@project_builder=''
     @@project_cleaner=''
     @@project_libdir=''
     
     
     def initialize
       @parser = CunitParser.new()
       @current_output = String.new("")
     end
     # set the executable file name to run CUNIT tests
     def self.set_runner(name)
       @@cunit_runner=name
     end
     
     # set command to run to prepare build
     def self.set_builder(name)
       @@project_builder=name
     end
     
      # set cleaner script/exe/command
     def self.set_cleaner(name)
       @@project_cleaner=name
     end
     
     
      # set directory where library under test is generated
     def self.set_libdir(name)
       @@project_libdir=name
     end

     #
     # run one phase of the guard via a system command/executable
     #
     def run_task(task_executable)
       success = true
       IO.popen(task_executable.split << {:err=>[:child, :out]})  do |myio|
         @current_output = myio.read
       end
       success = false unless $?.exitstatus == 0
       UI.info @current_output
       success
     end
     
     # run clean before each run all start with clean
     def run_clean
       raise "Clean failed" unless  run_task(@@project_cleaner) == true
     end
     
     # run unit tests via cunit executable
     def run_tests
       # setup environment so it should include lib dir for ld path
       ENV["LD_LIBRARY_PATH"]="#{ENV["LD_LIBRARY_PATH"]}:#{@@project_libdir}"
       
       if( !File.exists? (@@cunit_runner) )
         Notifier.notify("Pending", :title => "Test Not Defined", :image => :pending, :priority => 2)
         success = false
       else
         success = run_task(@@cunit_runner)
          @parser.parse_output(@current_output)
         if success == true
           Notifier.notify("Success", :title => "Test Passed", :image => :passed, :priority => 2)
         else
           Notifier.notify(@parser.failures_output, :title => "Test Failed", :image => :failed, :priority => 2 )
         end
       end
       raise "Test failed" unless success == true
     end
     
     
     # run make command to build the project
     def run_make
       success = run_task(@@project_builder)
       Notifier.notify("Failed", :title => "Build Failed", :image => :failed, :priority => 2) unless success == true
       raise "Build failed" unless success == true
     end
     # run them all
     def run 
       UI.info "Test runner: #{@@cunit_runner}"
       UI.info "Builder:  #{@@project_builder}"
       UI.info "Cleaner: #{@@project_cleaner}"
       UI.info "Libdir: #{@@project_libdir}"
       begin
         run_clean
         run_make 
         run_tests
       rescue
         return false
       end
       true
     end
     
   end
 end
end
