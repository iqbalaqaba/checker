require "spec_helper"

describe Checker::Modules::Haml do
  it "should only check .haml files" do
    files = ["a.rb", "b.js.erb", "c.r", "d.yml", "e.yaml", "f.coffee", "g.haml"]
    mod = Checker::Modules::Haml.new(files)
    allow(mod).to receive(:check_for_executable).and_return(true)
    allow(mod).to receive(:check_one_file).and_return(double(success?: true, status: :ok))
    expect(mod).to receive(:check_one_file).with("g.haml")
    expect(mod).not_to receive(:check_one_file).with("f.coffee")
    expect(mod).not_to receive(:check_one_file).with("e.yaml")
    expect(mod).not_to receive(:check_one_file).with("d.yml")
    expect(mod).not_to receive(:check_one_file).with("a.rb")
    expect(mod).not_to receive(:check_one_file).with("b.js.erb")
    expect(mod).not_to receive(:check_one_file).with("c.r")
    mod.check
  end
end
