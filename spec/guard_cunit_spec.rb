require "spec_helper.rb"

describe Guard::Cunit do

  before (:all) do
    @@first = true
    @tmp_env = TempPrjEnv.new
    @work_dir = Dir.getwd
  end

 def get_ld_path
	case RUBY_PLATFORM	
		when /mingw/
			ENV["PATH"]
		when /mswin/
			ENV["PATH"]
		when /darwin/
			ENV["DYLD_LIBRARY_PATH"]
		else
			ENV["LD_LIBRARY_PATH"]
		end
 end
  def setup_guard
    if @@first == true
      Guard::setup({:no_interactions => true})
      @@first = false
    else
      Guard::reload({})
    end
  end

  before(:each) do
    Dir.chdir(@work_dir)
    tmp_work_dir=@tmp_env.create_tmp_prj_dir
    Dir.chdir((tmp_work_dir))
    Guard::UI.stub(:info)
    IO.stub(:popen)
  end

  after(:each) do
    Dir.chdir(@work_dir)
    @tmp_env.cleanup_tmp_prj_dir
  end

  it "should inherit Guard class" do
    subject.class.ancestors.should include(Guard::Guard)
  end

  context "Run guard" do

    it "should run build" do

      guardfile_has_unit_test_exe()
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("./#{File.basename(Dir.getwd)}_unit",:pass)
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
      
    end


    it "should run build on changes " do
      
      cguard = Guard::Cunit.new
      cguard.stub(:run_all).and_return(true)
      Guard::UI.should_receive(:info).with("Process changes in #{File.basename(Dir.getwd)}")
      
      cguard.run_on_change("#{File.basename(Dir.getwd)}")
      
    end

    it "should set libpath for executbles with current project directory by default" do
	  oldenv=get_ld_path
            
      guardfile_has_unit_test_exe(:test_exe=>"jiji")
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("./jiji",:pass)
      
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
      newenv =get_ld_path
      newenv.should include("#{oldenv}")
	  newenv.should include("#{Dir.getwd}")
      get_ld_path=oldenv
    end


    it "should set libpath to predefined lib directory when user has specified such in the Guardfile" do
      oldenv=get_ld_path
      
      guardfile_has_unit_test_exe(:test_exe=>"jiji",:libdir=>'lib')
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("./jiji",:pass)
      
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
      newenv =get_ld_path
      newenv.should include("#{oldenv}")
	  newenv.should include("#{File.join(Dir.getwd,"lib")}")
      get_ld_path=oldenv     
    end


    it "should run cunit test define in the Guardfile" do
      guardfile_has_unit_test_exe(:test_exe =>"didi")
      
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")


      fake_test_exe("./didi",:pass)
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
      
    end


    it "should run predefined build command" do 
      guardfile_has_unit_test_exe(:test_exe =>"jiji",:builder => "./make_all.sh")
      fake_test_exe("./jiji",:pass)
      popen_successfull_fake("./make_all.sh")
      
      popen_successfull_fake("make clean")
            
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run

    end

    it "should run predefined clean command" do 
      guardfile_has_unit_test_exe(:test_exe =>"jiji",:builder => "./make_all.sh",:cleaner=> "./clean_all.sh")
      fake_test_exe("./jiji",:pass)
      popen_successfull_fake("./make_all.sh")
      popen_successfull_fake("./clean_all.sh")
      cguard = Guard::Cunit::Runner.new
    setup_guard
      cguard.run

    end

  end


  context "Handle exit codes" do
    it "should report failure on build failed" do
      guardfile_has_unit_test_exe()
      popen_successfull_fake("make clean")
      popen_failing_fake("make 2>&1")
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run.should == false
    end

    it "should block further tasks on build failed" do
      guardfile_has_unit_test_exe(:test_exe=>"jiji")
      popen_successfull_fake("make clean")
      popen_failing_fake("make 2>&1")
      f = File.new("./jiji", "w+", 0666)
      f.close
      IO.stub(:popen).with("jiji".split << {:err=>[:child, :out]})
      IO.should_not_receive(:popen).with("jiji".split << {:err=>[:child, :out]}) 
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run.should == false
    end


    it "should report failure on test failed" do
      guardfile_has_unit_test_exe(:test_exe=>"jiji")
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("./jiji",:fail)
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run.should == false
    end

  end


  context "Displaying notifications" do

    it "should display failure if build fails" do
      Guard::Notifier.stub(:notify) 
      guardfile_has_unit_test_exe()
      Guard::Notifier.should_receive(:notify).with("Failed", :title => "Build Failed", :image => :failed, :priority => 2)
      popen_successfull_fake("make clean")
      popen_failing_fake("make 2>&1")
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
    end

    it "should display failure if test fails" do
      IO.stub(:popen)
      Guard::Notifier.stub(:notify) 
      guardfile_has_unit_test_exe(:test_exe=>"jiji")
      Guard::Notifier.should_receive(:notify).with( anything(), :title => "Test Failed", :image => :failed, :priority => 2 )
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("./jiji",:fail)
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
    end

    it "should display pending if test is absent" do
      Guard::Notifier.stub(:notify) 
      guardfile_has_unit_test_exe()
      Guard::Notifier.should_receive(:notify).with("Pending", :title => "Test Not Defined", :image => :pending, :priority => 2)
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
    end

    it "should display success if build and test succeeded" do
      Guard::Notifier.stub(:notify) 
      guardfile_has_unit_test_exe()
      Guard::Notifier.should_receive(:notify).with("Success", :title => "Test Passed", :image => :success, :priority => 2)
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe(nil,:pass)
      cguard = Guard::Cunit::Runner.new
      Guard.add_guard('cunit')
      cguard.run
    end
  end

end
