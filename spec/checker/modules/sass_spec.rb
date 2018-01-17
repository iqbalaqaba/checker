require "spec_helper"

describe Checker::Modules::Sass do
  it "should only check .sass and .scss files" do
    files = ["a.rb", "b.js.erb", "c.r", "d.yml", "e.yaml", "f.coffee", "g.haml", "h.js", "i.scss", "j.sass"]
    mod = Checker::Modules::Sass.new(files)
    allow(mod).to receive(:check_for_executable).and_return(true)
    allow(mod).to receive(:check_one_file).and_return(double(success?: true, status: :ok))
    expect(mod).to receive(:check_one_file).with("j.sass")
    expect(mod).to receive(:check_one_file).with("i.scss")
    expect(mod).not_to receive(:check_one_file).with("h.js")
    expect(mod).not_to receive(:check_one_file).with("g.haml")
    expect(mod).not_to receive(:check_one_file).with("f.coffee")
    expect(mod).not_to receive(:check_one_file).with("e.yaml")
    expect(mod).not_to receive(:check_one_file).with("d.yml")
    expect(mod).not_to receive(:check_one_file).with("a.rb")
    expect(mod).not_to receive(:check_one_file).with("b.js.erb")
    expect(mod).not_to receive(:check_one_file).with("c.r")
    mod.check
  end

  context "normal check" do
    before do
      allow(Checker::Options).to receive(:use_rails_for_sass).and_return(false)
    end

    it "gives proper command to sass module while checking .sass files" do
      files = ["a.sass"]
      mod = Checker::Modules::Sass.new(files)
      allow(mod).to receive(:check_for_executable).and_return(true)
      expect(mod).to receive(:plain_command).with("sass  -c a.sass").and_return(0)
      mod.check
    end

    it "gives proper command to sass module while checking .scss files" do
      files = ["a.scss"]
      mod = Checker::Modules::Sass.new(files)
      allow(mod).to receive(:check_for_executable).and_return(true)
      expect(mod).to receive(:plain_command).with("sass --scss -c a.scss").and_return(0)
      mod.check
    end
  end

  context "rails check" do
    before do
      allow(Checker::Options).to receive(:use_rails_for_sass).and_return(true)
    end

    after do
      `rm -rf spec/assets/stylesheets/checker-cache*`
    end

    it "runs rails check if preconditions_for_rails are met" do
      files = ["a.sass"]
      mod = Checker::Modules::Sass.new(files)
      allow(mod).to receive(:preconditions_for_rails?).and_return(true)
      allow(mod).to receive(:rails_project?).and_return(true)
      allow(mod).to receive(:rails_with_ap?).and_return(true)
      allow(mod).to receive(:check_for_executable).and_return(true)
      allow(mod).to receive(:stylesheets_dir).and_return("spec/assets/stylesheets/")
      expect(mod).to receive(:rails_check).and_return(Checker::Result.result(mod, 0))
      mod.check
    end

    it "runs normal check if preconditions_for_rails aren't met" do
      files = ["a.sass"]
      mod = Checker::Modules::Sass.new(files)
      allow(mod).to receive(:preconditions_for_rails?).and_return(false)
      allow(mod).to receive(:rails_project?).and_return(true)
      allow(mod).to receive(:rails_with_ap?).and_return(true)
      allow(mod).to receive(:check_for_executable).and_return(true)
      allow(mod).to receive(:stylesheets_dir).and_return("spec/assets/stylesheets/")
      expect(mod).to receive(:normal_check).and_return(Checker::Result.result(mod, 0))
      mod.check
    end

    it "gives proper command to sass module while checking .sass files" do
      files = ["a.sass"]
      mod = Checker::Modules::Sass.new(files)
      allow(mod).to receive(:preconditions_for_rails?).and_return(true)
      allow(mod).to receive(:rails_project?).and_return(true)
      allow(mod).to receive(:rails_with_ap?).and_return(true)
      allow(mod).to receive(:check_for_executable).and_return(true)
      allow(mod).to receive(:stylesheets_dir).and_return("spec/assets/stylesheets/")
      expect(mod).to receive(:plain_command).with("rails runner \"Rails.application.assets.find_asset(\\\"#{Dir.pwd}/spec/assets/stylesheets/checker-cachea.sass\\\").to_s\"").and_return(0)
      mod.check
    end

    it "gives proper command to sass module while checking .scss files" do
      files = ["a.scss"]
      mod = Checker::Modules::Sass.new(files)
      allow(mod).to receive(:preconditions_for_rails?).and_return(true)
      allow(mod).to receive(:rails_project?).and_return(true)
      allow(mod).to receive(:rails_with_ap?).and_return(true)
      allow(mod).to receive(:check_for_executable).and_return(true)
      allow(mod).to receive(:stylesheets_dir).and_return("spec/assets/stylesheets/")
      expect(mod).to receive(:plain_command).with("rails runner \"Rails.application.assets.find_asset(\\\"#{Dir.pwd}/spec/assets/stylesheets/checker-cachea.scss\\\").to_s\"").and_return(0)
      mod.check
    end
  end
end
