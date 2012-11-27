require "spec_helper.rb"


describe Guard::Cunit::CunitParser do
  before(:each) do

@long_fake_output =  String.new("     CUnit - A unit testing framework for C - Version 2.1-2
     http://cunit.sourceforge.net/

Suite  Simple calc CUNIT suite, Test Addition test had failures:
    1. simplecalc_test.c:7  - CU_FAIL(\"TODO\")
    2. simplecalc_test.c:17  - CU_FAIL(\"TODO\")
    3. simplecalc_test.c:27  - CU_FAIL(\"TODO\")
    4. simplecalc_test.c:37  - CU_FAIL(\"TODO\")
    5. simplecalc_test.c:47  - CU_FAIL(\"TODO\")
    6. simplecalc_test.c:57  - CU_FAIL(\"TODO\")
    7. simplecalc_test.c:67  - CU_FAIL(\"TODO\")
    8. simplecalc_test.c:77  - CU_FAIL(\"TODO\")
    9. simplecalc_test.c:87  - CU_FAIL(\"TODO\")
    10. simplecalc_test.c:97  - CU_FAIL(\"TODO\")


Run Summary:    Type  Total    Ran Passed Failed Inactive
              suites      1      1    n/a      0        0
               tests     10     10      0     10        0
             asserts     10     10      0     10      n/a

Elapsed time =    0.000 seconds")


@fake_output =  String.new("     CUnit - A unit testing framework for C - Version 2.1-2
     http://cunit.sourceforge.net/

Suite  Simple calc CUNIT suite, Test Addition test had failures:
    1. simplecalc_test.c:7  - CU_FAIL(\"TODO\")

Run Summary:    Type  Total    Ran Passed Failed Inactive
              suites      1      1    n/a      0        0
               tests      1      1      0      1        0
             asserts      1      1      0      1      n/a

Elapsed time =    0.000 seconds")

@fake_fail_summary = String.new("1. simplecalc_test.c:7  - CU_FAIL(\"TODO\")")

@fake_summary = String.new("Run Summary:    Type  Total    Ran Passed Failed Inactive
              suites      1      1    n/a      0        0
               tests      1      1      0      1        0
             asserts      1      1      0      1      n/a

Elapsed time =    0.000 seconds")

@shortened_fail_summary = String.new("1. simplecalc_test.c:7  - CU_FAIL(\"TODO\")
    2. simplecalc_test.c:17  - CU_FAIL(\"TODO\")
    3. simplecalc_test.c:27  - CU_FAIL(\"TODO\")
...")

  end


  it "should generate a UI summary and full output from given text input" do
    parser = Guard::Cunit::CunitParser.new(@fake_output)
    parser.full_output.should == @fake_output
    parser.cunit_output.should == (@fake_summary)
    parser.failures_output.should == (@fake_fail_summary)
  end

  it "failure summary should be maximum a 3 row output" do
    parser = Guard::Cunit::CunitParser.new(@long_fake_output)
    parser.failures_output.should == (@shortened_fail_summary)
  end

  it "should be able to init with no output and later trigger process" do
    parser = Guard::Cunit::CunitParser.new()
    parser.parse_output(@long_fake_output)
    parser.failures_output.should == (@shortened_fail_summary)
  end
  it "should be able to handle test exe with no output and put just failed as failure message" do
    parser = Guard::Cunit::CunitParser.new()
    parser.parse_output(nil)
    parser.failures_output.should == ("Failed")
  end
end
