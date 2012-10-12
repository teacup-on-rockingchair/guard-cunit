module Guard
  class Cunit
   class CunitParser
     @output
     def initialize (task_output)
       parse_output( task_output )
     end

     def parse_output( task_output )
       @output = task_output
     end

     def full_output
       @output
     end

   end
 end
end
