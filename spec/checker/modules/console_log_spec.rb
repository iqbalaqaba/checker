require 'spec_helper'

describe Checker::Modules::ConsoleLog do
  it 'checks coffee and js files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yaml', 'e.yml', 'f.coffee', 'g.js']
    mod = Checker::Modules::ConsoleLog.new(files)
    allow(mod).to receive(:check_one).and_return(double(:success? => true, :status => :ok))
    expect(mod).to receive(:check_one).exactly(2).times
    mod.check
  end

  describe "does find console.log" do
    before do
      files = [fixture("console_log", "with_console_log.js")]
      @mod = Checker::Modules::ConsoleLog.new(files)
    end

    it "results to be true if prevent_commit_on_warning is set to false" do
      allow(Checker::Options).to receive(:prevent_commit_on_warning).and_return(false)
      expect(@mod.check).to be_truthy
    end

    it "results to be false if prevent_commit_on_warning is set to true" do
      allow(Checker::Options).to receive(:prevent_commit_on_warning).and_return(true)
      expect(@mod.check).to be_falsey
    end

    it "prints proper message" do
      expect(@mod).to receive(:print_warning_message)
      @mod.check
    end
  end

  describe "does not find console.log" do
    before do
      files = [fixture("console_log", "without_console_log.js")]
      @mod = Checker::Modules::ConsoleLog.new(files)
    end

    it "results to be true" do
      expect(@mod.check).to be_truthy
    end

    it "prints proper message" do
      expect(@mod).to receive(:print_success_message)
      @mod.check
    end
  end
end
