module Guard
  class Cunit
   class CunitParser
     @output
     @summary_output
     def initialize (task_output)
       @output = String.new("")
       parse_output( task_output )
       get_summary
       get_failures
     end

     def parse_output( task_output )
       @output = task_output.dup
     end
     
     def get_summary
       @summary_output = @output[/Run Summary:[\w\W]*/]
     end

     def get_failures
       @failures = @output[/Suite[\w\W]*/]
       puts @failures
       @failures = @failures.sub(@summary_output,"")
     end

     def cunit_output
       @summary_output
     end

     def full_output
       @output
     end

     def failures_output
     end

   end
 end
end
