require 'spec_helper'

describe Checker::Modules::Javascript do
  it 'should only check .js files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yml', 'e.yaml', 'f.coffee', 'g.haml', 'h.js']
    mod = Checker::Modules::Javascript.new(files)
    mod.stub(:check_for_executable).and_return(true)
    mod.should_receive(:check_one_file).with('h.js').and_return(stub(:success? => true, :status => :ok))
    mod.should_not_receive(:check_one_file).with('g.haml')
    mod.should_not_receive(:check_one_file).with('f.coffee')
    mod.should_not_receive(:check_one_file).with('e.yaml')
    mod.should_not_receive(:check_one_file).with('d.yml')
    mod.should_not_receive(:check_one_file).with('a.rb')
    mod.should_not_receive(:check_one_file).with('b.js.erb')
    mod.should_not_receive(:check_one_file).with('c.r')
    mod.check 
  end

  describe "good js file" do
    before do
      files = ['good.js']
      @mod = Checker::Modules::Javascript.new(files)
      @mod.should_receive(:check_one_file).with('good.js').and_return(stub(:success? => true, :status => :ok))
    end

    it "results to be true" do
      @mod.check.should be_true
    end

    it "prints proper message" do
      @mod.should_receive(:print_success_message)
      @mod.check
    end
  end

  describe "js with warnings" do
    before do
      files = ['warning.js']
      @mod = Checker::Modules::Javascript.new(files)
      @mod.should_receive(:check_one_file).with('warning.js').and_return(stub(:success? => true, :status => :warning))
    end

    it "results to be true" do
      @mod.check.should be_true
    end

    it "prints proper message" do
      @mod.should_receive(:print_warning_message)
      @mod.check
    end
  end

  describe "bad js with errors" do
    before do
      files = ['bad.js']
      @mod = Checker::Modules::Javascript.new(files)
      @mod.should_receive(:check_one_file).with('bad.js').and_return(stub(:success? => false, :status => :fail))
    end

    it "results to be true" do
      @mod.check.should be_false
    end

    it "prints proper message" do
      @mod.should_receive(:print_fail_message)
      @mod.check
    end
  end
end
