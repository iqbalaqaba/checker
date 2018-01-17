require "spec_helper"

describe Checker::Modules::Yaml do
  it "should only check .yaml and .yml files" do
    files = ["a.rb", "b.js.erb", "c.r", "d.yml", "e.yaml"]
    mod = Checker::Modules::Yaml.new(files)
    allow(mod).to receive(:check_one_file).and_return(double(success?: true, status: :ok))
    expect(mod).to receive(:check_one_file).with("d.yml")
    expect(mod).to receive(:check_one_file).with("e.yaml")
    expect(mod).not_to receive(:check_one_file).with("a.rb")
    expect(mod).not_to receive(:check_one_file).with("b.js.erb")
    expect(mod).not_to receive(:check_one_file).with("c.r")
    mod.check
  end

  it "should properly fetch yaml files" do
    files = [fixture("yaml", "good.yaml")]
    mod = Checker::Modules::Yaml.new(files)
    expect(mod.check).to be true
  end

  it "should not pass the syntax check" do
    files = [fixture("yaml", "bad.yaml")]
    mod = Checker::Modules::Yaml.new(files)
    expect(mod.check).to be false
  end
end
