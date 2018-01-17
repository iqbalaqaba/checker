require 'spec_helper'

describe Checker::Modules::Coffeescript do
  it 'should only check .coffee files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yml', 'e.yaml', 'f.coffee']
    mod = Checker::Modules::Coffeescript.new(files)
    expect(mod).to receive(:check_for_executable).and_return(true)
    expect(mod).to receive(:check_one_file).with('f.coffee').and_return(double(:success? => true, :status => :ok))
    expect(mod).not_to receive(:check_one_file).with('e.yaml')
    expect(mod).not_to receive(:check_one_file).with('d.yml')
    expect(mod).not_to receive(:check_one_file).with('a.rb')
    expect(mod).not_to receive(:check_one_file).with('b.js.erb')
    expect(mod).not_to receive(:check_one_file).with('c.r')
    mod.check
  end
end
