class TestOutput < String
  # limit the output to given nr rows
  def limit_to_rows(number_of_rows)
    output = TestOutput.new("")
    raws_count = 1;
    self.lines.each do |current_line|
      output += current_line
      break if(raws_count == number_of_rows)
      raws_count+=1
    end
    output=output+"..." if ( number_of_rows < self.lines.count )
    output
  end
  
  # bang version
  def limit_to_rows!(number_of_rows)
    self.replace(limit_to_rows(number_of_rows))
  end

end


module Guard
  class Cunit
   class CunitParser
     @output
     @summary_output
     @failures

     #constructor
     def initialize (task_output = nil)
       parse_output( task_output ) unless task_output == nil
     end
     
     #get cunit output
     def parse_output( task_output )
       @output = TestOutput.new(task_output.dup)
       get_summary
       get_failures
     end
     
     # find summary of the cunit test reprot
     def get_summary
       begin
         @summary_output = TestOutput.new(@output[/Run Summary:[\w\W]*/])
       rescue
         @Summary_output = TestOutput.new("")
       end
     end

     #find failures from Cunit test report
     def get_failures
       begin
         @failures = TestOutput.new(@output[/Suite[\w\W]*/].sub(@summary_output,"").strip)
       rescue
         @failures = TestOutput.new("")
       end
       @failures.limit_to_rows!(3)
     end

     #display summary of the suites/tests/asserts
     def cunit_output
       @summary_output
     end

     #copy of the cunit output
     def full_output
       @output
     end

     #display failures output
     def failures_output
       @failures
     end

   end
 end
end
