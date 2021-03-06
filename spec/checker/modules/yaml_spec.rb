require 'spec_helper'

describe Checker::Modules::Yaml do
  it 'should only check .yaml and .yml files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yml', 'e.yaml']
    mod = Checker::Modules::Yaml.new(files)
    mod.stub(:check_one_file).and_return(stub(:success? => true, :status => :ok))
    mod.should_receive(:check_one_file).with('d.yml')
    mod.should_receive(:check_one_file).with('e.yaml')
    mod.should_not_receive(:check_one_file).with('a.rb')
    mod.should_not_receive(:check_one_file).with('b.js.erb')
    mod.should_not_receive(:check_one_file).with('c.r')
    mod.check 
  end

  it "should properly fetch yaml files" do
    files = [fixture("yaml", "good.yaml")]
    mod = Checker::Modules::Yaml.new(files)
    mod.check.should be_true
  end

  it "should not pass the syntax check" do
    files = [fixture("yaml", "bad.yaml")]
    mod = Checker::Modules::Yaml.new(files)
    mod.check.should be_false
  end
end
