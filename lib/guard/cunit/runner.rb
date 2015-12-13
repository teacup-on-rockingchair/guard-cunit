require 'guard/cunit/cunit_parser'

module Guard
  class Cunit < Plugin
    # the class implements running and handling results
    # of the tasks that made up the cunit guard
    class Runner
      @@cunit_runner = ''
      @@project_builder = ''
      @@project_cleaner = ''
      @@project_libdir = ''

      def initialize
        @parser = CunitParser.new
        @current_output = String.new('')
      end

      # set the executable file name to run CUNIT tests
      def self.cfg_runner(name)
        @@cunit_runner = name
      end

      # set command to run to prepare build
      def self.cfg_builder(name)
        @@project_builder = name
      end

      # set cleaner script/exe/command
      def self.cfg_cleaner(name)
        @@project_cleaner = name
      end

      # set directory where library under test is generated
      def self.cfg_libdir(name)
        @@project_libdir = name
      end

      # make wrapper for piping so we can use different
      # approaches on win and *nix
      def piper(exe)
        if RUBY_PLATFORM.match(/mingw/) || \
           RUBY_PLATFORM.match(/mswin/) || RUBY_VERSION.match('1.8')
          IO.popen(exe) do |io|
            yield io
          end
        else
          IO.popen([exe] << { err: [:child, :out] }) do |io|
            yield io
          end
        end
      end

      # run one phase of the guard via a system command/executable
      def run_task(task_executable)
        success = true
        piper(task_executable) do |myio|
          @current_output = myio.read
        end
        success = false unless $CHILD_STATUS.exitstatus == 0
        UI.info @current_output
        success
      end

      # run clean before each run all start with clean
      def run_clean
        fail 'Clean failed' unless run_task(@@project_cleaner) == true
      end

      def export_libdir(libdir)
        case RUBY_PLATFORM
        when /mingw/, /mswin/
          ENV['PATH'] = "#{ENV['PATH']};#{libdir}"
        when /darwin/
          ENV['DYLD_LIBRARY_PATH'] = "#{ENV['DYLD_LIBRARY_PATH']}:#{libdir}"
        else
          ENV['LD_LIBRARY_PATH'] = "#{ENV['LD_LIBRARY_PATH']}:#{libdir}"
        end
      end

      def parse_test_output(result)
        @parser.parse_output(@current_output)
        if result == true
          Notifier.notify('Success', title: 'Test Passed',
                                     image: :success, priority: 2)
        else
          Notifier.notify(@parser.failures_output, title: 'Test Failed',
                                                   image: :failed, priority: 2)
        end
      end

      def run_cunit
        if !File.exist?(@@cunit_runner)
          Notifier.notify('Pending', title: 'Test Not Defined',
                                     image: :pending, priority: 2)
          return false
        else
          success = run_task(@@cunit_runner)
          parse_output(success)
          return success
        end
      end

      # run unit tests via cunit executable
      def run_tests
        # setup environment so it should include lib dir for ld path
        export_libdir(@@project_libdir)
        success = run_cunit
        fail 'Test failed' unless success == true
      end

      # run make command to build the project
      def run_make
        success = run_task(@@project_builder)
        unless success == true
          Notifier.notify('Failed', title: 'Build Failed',
                                    image: :failed, priority: 2)
        end
        fail 'Build failed' unless success == true
      end

      def print_test_info
        UI.info "Test runner: #{@@cunit_runner}"
        UI.info "Builder:  #{@@project_builder}"
        UI.info "Cleaner: #{@@project_cleaner}"
        UI.info "Libdir: #{@@project_libdir}"
      end

      # run them all
      def run
        print_test_info
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
