# couple of methods I need for String objects
class TestOutput < String
  # limit the output to given nr rows
  def limit_to_rows(number_of_rows)
    output = TestOutput.new('')
    raws_count = 1
    lines.each do |current_line|
      output += current_line
      break if raws_count == number_of_rows
      raws_count += 1
    end
    output += '...' if number_of_rows < lines.count
    output
  end

  # bang version
  def limit_to_rows!(number_of_rows)
    replace(limit_to_rows(number_of_rows))
  end
end

module Guard
  class Cunit < Plugin
    # Parse CUNIT test harness output
    class CunitParser
      # constructor
      def initialize(task_output = nil)
        parse_output(task_output) unless task_output.nil?
      end

      # get cunit output
      def parse_output(task_output)
        task_output = '' if task_output.nil?
        @output = TestOutput.new(task_output.dup)
        read_summary
        read_failures
      end

      # find summary of the cunit test reprot
      def read_summary
        summary_txt = ''
        begin
          summary_txt = @output[/Run Summary:[\w\W]*/] || ''
        rescue
          summary_txt = ''
        end
        @summary_output = TestOutput.new(summary_txt)
      end

      # find failures from Cunit test report
      def read_failures
        begin
          failures_rex = /[\r\n]*[ \t\f]*1. [\w\W]*:[\d]* [\w\W]*/
          outp = @output[failures_rex].sub(@summary_output, '').strip
          @failures = TestOutput.new(outp)
        rescue
          @failures = TestOutput.new('Failed')
        end
        @failures.limit_to_rows!(3)
      end

      # display summary of the suites/tests/asserts
      def cunit_output
        @summary_output
      end

      # copy of the cunit output
      def full_output
        @output
      end

      # display failures output
      def failures_output
        @failures
      end
    end
  end
end
