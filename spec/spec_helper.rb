require 'rubygems'
require 'guard'
require 'guard/cunit'
require 'guard/cunit/runner'
require 'guard/cunit/cunit_parser'
require 'rspec'

# a class to set/cleanup environment for fake project
class TempPrjEnv

  @test_tmp = "./tmp"
  @test_prj_dir="./tmp/1test_prj"

  # create a tmp subdir and within it fake project directory
  def self.create_tmp_prj_dir
    begin
      Dir.mkdir(@test_tmp)
      Dir.mkdir(@test_prj_dir)
    rescue
    end
    @test_prj_dir
  end

  # cleanup the subdir
  def self.cleanup_tmp_prj_dir
    begin
      FileUtils.rm_rf(@test_prj_dir)
      FileUtils.rm_rf(@test_tmp)
    rescue
      puts "Could not remove dirs"
    end
  end
end


#define fake script to return given exit code
def fake_script(code)
	
	case RUBY_PLATFORM	
		when /mingw/
			`exit #{code}`
		when /mswin/
			`exit #{code}`
		else
			`(exit #{code})`
		end
end

#define fake script to return success
def fake_success
	fake_script(0)
end
#define fake script to return success
def fake_fail
	fake_script(1)
end

# setup stub for system command with successful exit result
def popen_successfull_fake(fakename)
  IO.stub(:popen).with(fakename.split << {:err=>[:child, :out]})	
  IO.should_receive(:popen).with(fakename.split << {:err=>[:child, :out]})  { fake_success}
end

# setup stub for system command with failing exit result
def popen_failing_fake(fakename)
  IO.stub(:popen).with(fakename.split << {:err=>[:child, :out]}) 
  IO.should_receive(:popen).with(fakename.split << {:err=>[:child, :out]})   { fake_fail }
end

# fake the test executable runner, its existance and result
def fake_test_exe(exe_name,successful = :fail)
  exe_name="./#{File.basename(Dir.getwd)}_unit" unless exe_name != nil
  File.new(exe_name,"w+")
  if successful == :pass
    popen_successfull_fake(exe_name)
  else
    popen_failing_fake(exe_name)
  end
end

# a generator for CUnit Guardfile
def guardfile_has_unit_test_exe(params={ :test_exe=>nil, :builder=>nil, :cleaner=>nil, :libdir=>nil})
  File.open("Guardfile","w+",0644) do |file|
    file.puts "guard \'cunit\'  do"
    
    file.puts " set_builder \"#{params[:builder]}\"" unless (params[:builder] == nil)
    file.puts " set_cleaner \"#{params[:cleaner]}\"" unless (params[:cleaner] == nil)
    file.puts " cunit_runner \"./#{params[:test_exe]}\"" unless (params[:test_exe] == nil)
    file.puts " libdir \"#{params[:libdir]}\"" unless (params[:libdir] == nil)
    
    file.puts '    watch(%r{((.+)\.c$)|((.+)\.h$)|((M|m)akefile$)} )	'
    file.puts 'end'
  end
end

