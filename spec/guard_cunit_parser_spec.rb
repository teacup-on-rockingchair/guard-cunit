require "spec_helper.rb"


describe Guard::Cunit::CunitParser do

  before(:each) do
    tmp_work_dir=TempPrjEnv.create_tmp_prj_dir
    @work_dir = Dir.getwd
    Dir.chdir(tmp_work_dir)
    Guard::UI.stub(:info)
     IO.stub(:popen)
  end

  after(:each) do
    Dir.chdir(@work_dir)
    TempPrjEnv.cleanup_tmp_prj_dir
  end

  it "should generate a UI summary and full output from given text input" do
    pending
  end
  it "summary should be maximum a 3 row output" do
    pending
  end
  it "summary should start witht the first raw of error reported" do
    pending
  end
  
end
