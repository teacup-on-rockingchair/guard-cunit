require "spec_helper.rb"


describe Guard::Cunit do

  before(:each) do
    tmp_work_dir=TempPrjEnv.create_tmp_prj_dir
    @work_dir = Dir.getwd
    Dir.chdir(tmp_work_dir)
  end

  after(:each) do
    Dir.chdir(@work_dir)
    TempPrjEnv.cleanup_tmp_prj_dir
  end

  it "should inherit Guard class" do
    subject.class.ancestors.should include(Guard::Guard)
  end

  context "Run guard" do

    it "should run build" do
     IO.stub(:popen)
      guardfile_has_unit_test_exe()
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("#{File.basename(Dir.getwd)}_unit",:pass)
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run
      
    end

    it "should set libpath for executbles with current project directory by default" do
      IO.stub(:popen)
      oldenv=ENV["LD_LIBRARY_PATH"]
      guardfile_has_unit_test_exe()
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run
      newenv =ENV["LD_LIBRARY_PATH"]
      newenv.should match("#{oldenv}:#{Dir.getwd}")
      ENV["LD_LIBRARY_PATH"]=oldenv
    end
    it "should set libpath to predefined lib directory when user has specified such in the Guardfile" do
      IO.stub(:popen)
      oldenv=ENV["LD_LIBRARY_PATH"]
      guardfile_has_unit_test_exe(:libdir=>'./lib')
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run
      newenv =ENV["LD_LIBRARY_PATH"]
      newenv.should match("#{oldenv}:#{Dir.getwd}/lib")
      ENV["LD_LIBRARY_PATH"]=oldenv      
    end

    it "should run cunit test define in the Guardfile" do
      IO.stub(:popen)
      guardfile_has_unit_test_exe(:test_exe => "jiji")
      fake_test_exe("jiji",:pass)
      cguard = Guard::Cunit.new
      Guard::setup
      cguard.run_all

      guardfile_has_unit_test_exe(:test_exe =>"didi")
      fake_test_exe("didi",:pass)
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run
      
    end


    it "should run predefined build command" do 
      IO.stub(:popen)
      guardfile_has_unit_test_exe(:test_exe =>"jiji",:builder => "./make_all.sh")
      fake_test_exe("jiji",:pass)

      popen_successfull_fake("./make_all.sh")
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run

    end
    it "should run predefined clean command" do 
      IO.stub(:popen)
      guardfile_has_unit_test_exe(:test_exe =>"jiji",:builder => "./make_all.sh",:cleaner=> "./clean_all.sh")
      fake_test_exe("jiji",:pass)
      popen_successfull_fake("./make_all.sh")
      popen_successfull_fake("./clean_all.sh")
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run

    end

  end
  context "Handle exit codes" do
    it "should report failure on build failed" do
      IO.stub(:popen)
      guardfile_has_unit_test_exe()

      popen_successfull_fake("make clean")
      popen_failing_fake("make 2>&1")
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run.should == false
    end

    it "should report failure on test failed" do
      IO.stub(:popen)
      guardfile_has_unit_test_exe(:test_exe=>"jiji")

      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("jiji",:fail)
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run.should == false
    end

  end
  context "Displaying notifications" do

    it "should display failure if build fails" do
      IO.stub(:popen)
      Guard::Notifier.stub(:notify) 
      guardfile_has_unit_test_exe()
      Guard::Notifier.should_receive(:notify).with("Failed", :title => "Build Failed", :image => :failed, :priority => 2)
      popen_successfull_fake("make clean")
      popen_failing_fake("make 2>&1")
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run
    end

    it "should display failure if test fails" do
      IO.stub(:popen)
      Guard::Notifier.stub(:notify) 
      guardfile_has_unit_test_exe(:test_exe=>"jiji")
      Guard::Notifier.should_receive(:notify).with("Failed", :title => "Test Failed", :image => :failed, :priority => 2)
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("jiji",:fail)
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run
    end
    it "should display pending if test is absent" do
      IO.stub(:popen)
      Guard::Notifier.stub(:notify) 
      guardfile_has_unit_test_exe()
      Guard::Notifier.should_receive(:notify).with("Pending", :title => "Test Not Defined", :image => :pending, :priority => 2)
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      cguard = Guard::Cunit::Runner.new
      Guard::setup
      cguard.run
    end
    it "should display success if build and test succeeded" do
      IO.stub(:popen)
      Guard::Notifier.stub(:notify) 
      guardfile_has_unit_test_exe()
      Guard::Notifier.should_receive(:notify).with("Success", :title => "Test Passed", :image => :passed, :priority => 2)
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe(nil,:pass)
      cguard = Guard::Cunit::Runner.new
      Guard.add_guard('cunit')
      cguard.run
    end
  end

end
