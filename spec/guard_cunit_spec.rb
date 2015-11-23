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
      options = ::Guard.state.session.evaluator_options
      evaluator = ::Guard::Guardfile::Evaluator.new(options)
      evaluator.evaluate
    end
  end

  before(:each) do
    Dir.chdir(@work_dir)
    tmp_work_dir=@tmp_env.create_tmp_prj_dir
    Dir.chdir((tmp_work_dir))
    allow(Guard::UI).to receive(:info)
    allow(IO).to receive(:popen)
  end

  after(:each) do
    Dir.chdir(@work_dir)
    @tmp_env.cleanup_tmp_prj_dir
  end

  it "should inherit Guard class" do
    expect(Guard::Cunit.ancestors).to include(Guard::Plugin)
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
      expect(cguard).to receive(:run_all).and_return(true)
      expect(Guard::UI).to receive(:info).with("Process changes in #{File.basename(Dir.getwd)}")
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
      expect(newenv).to include("#{oldenv}")
      expect(newenv).to include("#{Dir.getwd}")
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
      expect(newenv).to include("#{oldenv}")
      expect(newenv).to include("#{File.join(Dir.getwd,"lib")}")
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
      expect(cguard.run).to eq false
    end

    it "should block further tasks on build failed" do
      guardfile_has_unit_test_exe(:test_exe=>"jiji")
      popen_successfull_fake("make clean")
      popen_failing_fake("make 2>&1")
      f = File.new("./jiji", "w+", 0666)
      f.close
      allow(IO).to receive(:popen).with("jiji".split << {:err=>[:child, :out]})
      expect(IO).not_to receive(:popen).with("jiji".split << {:err=>[:child, :out]}) 
      cguard = Guard::Cunit::Runner.new
      setup_guard
      expect(cguard.run).to eq false
    end


    it "should report failure on test failed" do
      guardfile_has_unit_test_exe(:test_exe=>"jiji")
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("./jiji",:fail)
      cguard = Guard::Cunit::Runner.new
      setup_guard
      expect(cguard.run).to eq  false
    end

  end


  context "Displaying notifications" do

    it "should display failure if build fails" do
      allow(Guard::Notifier).to receive(:notify) 
      guardfile_has_unit_test_exe()
      allow(Guard::Notifier).to receive(:notify).with("Failed", :title => "Build Failed", :image => :failed, :priority => 2)
      popen_successfull_fake("make clean")
      popen_failing_fake("make 2>&1")
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
    end

    it "should display failure if test fails" do
      allow(IO).to receive(:popen)
      allow(Guard::Notifier).to receive(:notify) 
      guardfile_has_unit_test_exe(:test_exe=>"jiji")
      allow(Guard::Notifier).to receive(:notify).with( anything(), :title => "Test Failed", :image => :failed, :priority => 2 )
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe("./jiji",:fail)
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
    end

    it "should display pending if test is absent" do
      allow(Guard::Notifier).to receive(:notify) 
      guardfile_has_unit_test_exe()
      allow(Guard::Notifier).to receive(:notify).with("Pending", :title => "Test Not Defined", :image => :pending, :priority => 2)
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      cguard = Guard::Cunit::Runner.new
      setup_guard
      cguard.run
    end

    it "should display success if build and test succeeded" do
      allow(Guard::Notifier).to receive(:notify) 
      guardfile_has_unit_test_exe()
      allow(Guard::Notifier).to receive(:notify).with("Success", :title => "Test Passed", :image => :success, :priority => 2)
      popen_successfull_fake("make clean")
      popen_successfull_fake("make 2>&1")
      fake_test_exe(nil,:pass)
      cguard = Guard::Cunit::Runner.new
      Guard.state.session.plugins.add('cunit', Hash.new)
      cguard.run
    end
  end

end
