require 'spec_helper'

describe Checker::Modules::Pry do
  it 'should check all files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yaml', 'e.yml', 'f.coffee']
    mod = Checker::Modules::Pry.new(files)
    mod.stub(:check_one).and_return(stub(:success? => true, :status => :ok))
    mod.should_receive(:check_one).exactly(6).times
    mod.check 
  end

  it "should not find the pry or remote_pry" do
    files = [fixture("pry", "without_pry.rb")]
    mod = Checker::Modules::Pry.new(files)
    mod.check.should be_true
  end

  it "should find the pry or remote_pry" do
    files = [fixture("pry", "with_pry.rb")]
    mod = Checker::Modules::Pry.new(files)
    mod.check.should be_false
  end

  it "should find the pry or remote_pry" do
    files = [fixture("pry", "with_pry_remote.rb")]
    mod = Checker::Modules::Pry.new(files)
    mod.check.should be_false
  end

  it "should find the pry or remote_pry" do
    files = [fixture("pry", "with_both.rb")]
    mod = Checker::Modules::Pry.new(files)
    mod.check.should be_false
  end
end
