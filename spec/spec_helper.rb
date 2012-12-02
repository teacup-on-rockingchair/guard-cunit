require 'rubygems'
require 'fileutils'
require 'pathname'
require 'guard'
require 'guard/cunit'
require 'guard/cunit/runner'
require 'guard/cunit/cunit_parser'
require 'rspec'

# a class to set/cleanup environment for fake project
class TempPrjEnv
  def initialize
    @test_tmp = (Pathname.new(Dir.getwd)+"tmp").to_s
    @test_prj_dir= ((Pathname.new(Dir.getwd)+"tmp")+"1test_prj").to_s
  end

  # create a tmp subdir and within it fake project directory
  def create_tmp_prj_dir
    begin
      Dir.mkdir(@test_tmp,0777)
      Dir.mkdir(@test_prj_dir,0777)
    rescue Exception => e
      puts "Could not make #{@test_tmp} dirs at #{Dir.getwd} - #{e.to_s}"
    end
    @test_prj_dir 
  end

  # cleanup the subdir
  def cleanup_tmp_prj_dir
    begin
      FileUtils.rm_r(@test_tmp)
    rescue  Exception => e
      puts "Could not remove dirs #{e.to_s}"
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


#wrapper for popen for different platforms
def popen_fake(fakename,exp_result)

	if( RUBY_PLATFORM.match(/mingw/)||RUBY_PLATFORM.match(/mswin/)||RUBY_VERSION.match("1.8"))
		pipe_args = fakename		
	else
		pipe_args = fakename.split << {:err=>[:child, :out]}
	end
	
	IO.stub(:popen).with(pipe_args)	
	if exp_result == false
		IO.should_receive(:popen).with(pipe_args) { fake_script(1) }
	else	
		IO.should_receive(:popen).with(pipe_args) { fake_script(0) }
	end
end


# setup stub for system command with successful exit result
def popen_successfull_fake(fakename)
	 popen_fake(fakename,true)
end

# setup stub for system command with failing exit result
def popen_failing_fake(fakename)
	
	popen_fake(fakename,false)
end

# fake the test executable runner, its existance and result
def fake_test_exe(exe_name,successful = :fail)
  exe_name="./#{File.basename(Dir.getwd)}_unit" unless exe_name != nil
  f = File.new(exe_name, "w+", 0666)
  f.close
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

