require 'spec_helper'

describe Checker::Modules::Ruby do
  it 'should only check .rb files' do
    files = ['a.rb', 'b.js.erb', 'c.r']
    mod = Checker::Modules::Ruby.new(files)
    mod.stub(:check_one_file).and_return(stub(:success? => true, :status => :ok))
    mod.should_receive(:check_one_file).with('a.rb')
    mod.should_not_receive(:check_one_file).with('b.js.erb')
    mod.should_not_receive(:check_one_file).with('c.r')
    mod.check
  end


  it "should pass the syntax check" do
    files = [fixture("ruby", "good.rb")]
    mod = Checker::Modules::Ruby.new(files)
    mod.check.should be_true
  end

  it "should not pass the syntax check" do
    files = [fixture("ruby", "bad.rb")]
    mod = Checker::Modules::Ruby.new(files)
    mod.check.should be_false
  end
end
