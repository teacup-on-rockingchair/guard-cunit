require "spec_helper.rb"

test_tmp = "./tmp"
test_prj_dir="./tmp/1test_prj"

def stubDirClass
 # Dir.stub(:getwd).and_return ['/data/me_cunit_prj']
 # Dir.stub(:open).and_return [ '.','..']
  Dir.stub(:mkdir).and_return 0
end

def guardfile_has_unit_test_exe(params={ :test_exe=>nil, :builder=>nil, :cleaner=>nil, :libdir=>nil})
  File.open("Guardfile","w+",0644) do |file|
    file.puts "guard \'cunit\'  do"
    
    file.puts " set_builder \"#{params[:builder]}\"" unless (params[:builder] == nil)
    file.puts " set_cleaner \"#{params[:cleaner]}\"" unless (params[:cleaner] == nil)
    file.puts " cunit_runner \"#{params[:test_exe]}\"" unless (params[:test_exe] == nil)
    file.puts " libdir \"#{params[:libdir]}\"" unless (params[:libdir] == nil)
    
    file.puts '    watch(%r{((.+)\.c$)|((.+)\.h$)|((M|m)akefile$)} )	'
    file.puts 'end'
  end
end


def popen_successfull_fake(fakename)
  IO.stub(:popen).with(fakename)
  IO.should_receive(:popen).with(fakename)  { `(exit 0)`}
end

def popen_failing_fake(fakename)
  IO.stub(:popen).with(fakename)
  IO.should_receive(:popen).with(fakename)  { `(exit 1)`}
end



describe Guard::Cunit do
  before(:each) do
    begin
      Dir.mkdir(test_tmp)
      Dir.mkdir(test_prj_dir)
    rescue
    end
      @work_dir = Dir.getwd
      Dir.chdir(test_prj_dir)
    
  end

  after(:each) do
      Dir.chdir(@work_dir)

    begin
     FileUtils.rm_rf(test_prj_dir)
     FileUtils.rm_rf(test_tmp)
      
    rescue
      puts "Could not remove dirs"
    end
  end

  it "should inherit Guard class" do
    stubDirClass
    subject.class.ancestors.should include(Guard::Guard)
  end

  context "Run guard" do

    it "should run build" do
     IO.stub(:popen)
      guardfile_has_unit_test_exe()
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      popen_successfull_fake("#{File.basename(test_prj_dir)}_unit")
      cguard = Guard::Cunit.new
      Guard::setup
      cguard.run_all
      
    end

    it "should set libpath for executbles with current project directory by default" do
      IO.stub(:popen)
      oldenv=ENV["LD_LIBRARY_PATH"]
      guardfile_has_unit_test_exe()
      cguard = Guard::Cunit.new
      Guard::setup
      cguard.run_all
      newenv =ENV["LD_LIBRARY_PATH"]
      newenv.should match("#{oldenv}:#{Dir.getwd}")
      ENV["LD_LIBRARY_PATH"]=oldenv
    end
    it "should set libpath to predefined lib directory when user has specified such in the Guardfile" do
      IO.stub(:popen)
      oldenv=ENV["LD_LIBRARY_PATH"]
      guardfile_has_unit_test_exe(:libdir=>'./lib')
      cguard = Guard::Cunit.new
      Guard::setup
      cguard.run_all
      newenv =ENV["LD_LIBRARY_PATH"]
      newenv.should match("#{oldenv}:#{Dir.getwd}/lib")
      ENV["LD_LIBRARY_PATH"]=oldenv      
    end

    it "should run cunit test define in the Guardfile" do
      IO.stub(:popen)
      guardfile_has_unit_test_exe(:test_exe => "jiji")
      popen_successfull_fake("jiji")
      cguard = Guard::Cunit.new
      Guard::setup
      cguard.run_all

      guardfile_has_unit_test_exe(:test_exe =>"didi")
      popen_successfull_fake("didi")
      cguard = Guard::Cunit.new
      Guard::setup
      cguard.run_all
      
    end


    it "should run predefined build command" do 
      IO.stub(:popen)
      guardfile_has_unit_test_exe(:test_exe =>"jiji",:builder => "./make_all.sh")
      popen_successfull_fake("jiji")
      popen_successfull_fake("./make_all.sh")
      cguard = Guard::Cunit.new
      Guard::setup
      cguard.run_all

    end
    it "should run predefined clean command" do 
      IO.stub(:popen)
      guardfile_has_unit_test_exe(:test_exe =>"jiji",:builder => "./make_all.sh",:cleaner=> "./clean_all.sh")
      popen_successfull_fake("jiji")
      popen_successfull_fake("./make_all.sh")
      popen_successfull_fake("./clean_all.sh")
      cguard = Guard::Cunit.new
      Guard::setup
      cguard.run_all

    end

  end
  context "Handle exit codes" do
    it "should report failure on build failed" do
      IO.stub(:popen)
      guardfile_has_unit_test_exe()

      popen_successfull_fake("make clean")
      popen_failing_fake("make 2>&1")
      cguard = Guard::Cunit.new
      Guard::setup
      expect { cguard.run_all }.to throw_symbol(:task_has_failed)
    end

    it "should report failure on test failed" do
      IO.stub(:popen)
      guardfile_has_unit_test_exe(:test_exe=>"jiji")

      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      popen_failing_fake("jiji")
      cguard = Guard::Cunit.new
      Guard::setup
      expect { cguard.run_all }.to throw_symbol(:task_has_failed)
    end

  end
  context "Displaying notifications" do
    it "should display failure if build fails" do
      pending
    end
    it "should display failure if test fails" do
      pending
    end
    it "should display pending if test is absent" do
      pending
    end
    it "should display failure if build fails" do
      pending
    end
  end

end
