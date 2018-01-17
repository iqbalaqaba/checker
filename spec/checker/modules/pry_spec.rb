require 'spec_helper'

describe Checker::Modules::Pry do
  it 'should check all files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yaml', 'e.yml', 'f.coffee']
    mod = Checker::Modules::Pry.new(files)
    allow(mod).to receive(:check_one).and_return(double(:success? => true, :status => :ok))
    expect(mod).to receive(:check_one).exactly(6).times
    mod.check
  end

  it "should not find the pry or remote_pry" do
    files = [fixture("pry", "without_pry.rb")]
    mod = Checker::Modules::Pry.new(files)
    expect(mod.check).to be true
  end

  it "should find the pry or remote_pry" do
    files = [fixture("pry", "with_pry.rb")]
    mod = Checker::Modules::Pry.new(files)
    expect(mod.check).to be false
  end

  it "should find the pry or remote_pry" do
    files = [fixture("pry", "with_pry_remote.rb")]
    mod = Checker::Modules::Pry.new(files)
    expect(mod.check).to be false
  end

  it "should find the pry or remote_pry" do
    files = [fixture("pry", "with_both.rb")]
    mod = Checker::Modules::Pry.new(files)
    expect(mod.check).to be false
  end
end
