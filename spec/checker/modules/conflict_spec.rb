require 'spec_helper'

describe Checker::Modules::Conflict do
  it 'checks all files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yaml', 'e.yml', 'f.coffee']
    mod = Checker::Modules::Conflict.new(files)
    mod.stub(:check_one).and_return(stub(:success? => true, :status => :ok))
    mod.should_receive(:check_one).exactly(6).times
    mod.check 
  end

  it "does find git conflict" do
    files = [fixture("conflict", "with_conflict.rb")]
    mod = Checker::Modules::Conflict.new(files)
    mod.check.should be_false
  end

  it "does not find git conflict" do
    files = [fixture("conflict", "without_conflict.rb")]
    mod = Checker::Modules::Conflict.new(files)
    mod.check.should be_true
  end
end
