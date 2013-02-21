require 'spec_helper'

describe Checker::Modules::Coffeescript do
  it 'should only check .coffee files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yml', 'e.yaml', 'f.coffee']
    mod = Checker::Modules::Coffeescript.new(files)
    mod.stub(:check_for_executable).and_return(true)
    mod.should_receive(:check_one_file).with('f.coffee').and_return(stub(:success? => true, :status => :ok))
    mod.should_not_receive(:check_one_file).with('e.yaml')
    mod.should_not_receive(:check_one_file).with('d.yml')
    mod.should_not_receive(:check_one_file).with('a.rb')
    mod.should_not_receive(:check_one_file).with('b.js.erb')
    mod.should_not_receive(:check_one_file).with('c.r')
    mod.check 
  end
end
