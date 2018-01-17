require "spec_helper"

describe Checker::Modules::Javascript do
  it "should only check .js files" do
    files = ["a.rb", "b.js.erb", "c.r", "d.yml", "e.yaml", "f.coffee", "g.haml", "h.js"]
    mod = Checker::Modules::Javascript.new(files)
    allow(mod).to receive(:check_for_executable).and_return(true)
    expect(mod).to receive(:check_one_file).with("h.js").and_return(double(success?: true, status: :ok))
    expect(mod).not_to receive(:check_one_file).with("g.haml")
    expect(mod).not_to receive(:check_one_file).with("f.coffee")
    expect(mod).not_to receive(:check_one_file).with("e.yaml")
    expect(mod).not_to receive(:check_one_file).with("d.yml")
    expect(mod).not_to receive(:check_one_file).with("a.rb")
    expect(mod).not_to receive(:check_one_file).with("b.js.erb")
    expect(mod).not_to receive(:check_one_file).with("c.r")
    mod.check
  end

  describe "good js file" do
    before do
      files = ["good.js"]
      @mod = Checker::Modules::Javascript.new(files)
      expect(@mod).to receive(:check_one_file).with("good.js").and_return(double(success?: true, status: :ok))
    end

    xit "results to be true" do
      @mod.check.should be_true
    end

    xit "prints proper message" do
      expect(@mod).to receive(:print_success_message)
      @mod.check
    end
  end

  describe "js with warnings" do
    before do
      files = ["warning.js"]
      @mod = Checker::Modules::Javascript.new(files)
      expect(@mod).to receive(:check_one_file).with("warning.js").and_return(double(success?: true, status: :warning))
    end

    xit "results to be true" do
      @mod.check.should be_true
    end

    xit "prints proper message" do
      expect(@mod).to receive(:print_warning_message)
      @mod.check
    end
  end

  describe "bad js with errors" do
    before do
      files = ["bad.js"]
      @mod = Checker::Modules::Javascript.new(files)
      expect(@mod).to receive(:check_one_file).with("bad.js").and_return(double(success?: false, status: :fail))
    end

    xit "results to be true" do
      @mod.check.should be_false
    end

    xit "prints proper message" do
      expect(@mod).to receive(:print_fail_message)
      @mod.check
    end
  end
end
