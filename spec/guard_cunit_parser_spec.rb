require "spec_helper.rb"


describe Guard::Cunit::CunitParser do
  before(:each) do

@fake_output =  String.new("     CUnit - A unit testing framework for C - Version 2.1-2
     http://cunit.sourceforge.net/

Suite  Simple calc CUNIT suite, Test Addition test had failures:
    1. simplecalc_test.c:7  - CU_FAIL(\"TODO\")

Run Summary:    Type  Total    Ran Passed Failed Inactive
              suites      1      1    n/a      0        0
               tests      1      1      0      1        0
             asserts      1      1      0      1      n/a

Elapsed time =    0.000 seconds")

@fake_fail_summary = String.new("Suite  Simple calc CUNIT suite, Test Addition test had failures:
    1. simplecalc_test.c:7  - CU_FAIL(\"TODO\")")

@fake_summary = String.new("Run Summary:    Type  Total    Ran Passed Failed Inactive
              suites      1      1    n/a      0        0
               tests      1      1      0      1        0
             asserts      1      1      0      1      n/a

Elapsed time =    0.000 seconds")



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
    parser = Guard::Cunit::CunitParser.new(@fake_output)

    parser.full_output.should == @fake_output
    parser.cunit_output.should == (@fake_summary)
    parser.failures_output.should == (@fake_fail_summary)
  end
  it "summary should be maximum a 3 row output" do
    pending
  end
  it "summary should start witht the first raw of error reported" do
    pending
  end
  
end
