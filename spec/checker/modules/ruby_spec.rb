require 'spec_helper'

describe Checker::Modules::Ruby do
  it 'should only check .rb files' do
    files = ['a.rb', 'b.js.erb', 'c.r']
    mod = Checker::Modules::Ruby.new(files)
    allow(mod).to receive(:check_one_file).and_return(double(:success? => true, :status => :ok))
    expect(mod).to receive(:check_one_file).with('a.rb')
    expect(mod).not_to receive(:check_one_file).with('b.js.erb')
    expect(mod).not_to receive(:check_one_file).with('c.r')
    mod.check
  end


  it "should pass the syntax check" do
    files = [fixture("ruby", "good.rb")]
    mod = Checker::Modules::Ruby.new(files)
    expect(mod.check).to be true
  end

  it "should not pass the syntax check" do
    files = [fixture("ruby", "bad.rb")]
    mod = Checker::Modules::Ruby.new(files)
    expect(mod.check).to be false
  end
end
