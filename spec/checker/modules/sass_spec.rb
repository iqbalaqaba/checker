require 'spec_helper'

describe Checker::Modules::Sass do
  it 'should only check .sass and .scss files' do
    files = ['a.rb', 'b.js.erb', 'c.r', 'd.yml', 'e.yaml', 'f.coffee', 'g.haml', 'h.js', 'i.scss', 'j.sass']
    mod = Checker::Modules::Sass.new(files)
    mod.stub(:check_for_executable).and_return(true)
    mod.stub(:check_one_file).and_return(stub(:success? => true, :status => :ok))
    mod.should_receive(:check_one_file).with('j.sass')
    mod.should_receive(:check_one_file).with('i.scss')
    mod.should_not_receive(:check_one_file).with('h.js')
    mod.should_not_receive(:check_one_file).with('g.haml')
    mod.should_not_receive(:check_one_file).with('f.coffee')
    mod.should_not_receive(:check_one_file).with('e.yaml')
    mod.should_not_receive(:check_one_file).with('d.yml')
    mod.should_not_receive(:check_one_file).with('a.rb')
    mod.should_not_receive(:check_one_file).with('b.js.erb')
    mod.should_not_receive(:check_one_file).with('c.r')
    mod.check 
  end

  context "normal check" do
    before do
      Checker::Options.stub(:use_rails_for_sass).and_return(false)
    end

    it "gives proper command to sass module while checking .sass files" do
      files = ["a.sass"]
      mod = Checker::Modules::Sass.new(files)
      mod.stub(:check_for_executable).and_return(true)
      mod.should_receive(:plain_command).with("sass  -c .checker-cache/69cb154f5eeff19216d2879872ba6569").and_return(0)
      mod.check
    end

    it "gives proper command to sass module while checking .scss files" do
      files = ["a.scss"]
      mod = Checker::Modules::Sass.new(files)
      mod.stub(:check_for_executable).and_return(true)
      mod.should_receive(:plain_command).with("sass --scss -c .checker-cache/13dbadc466ed1f9bdfbb2b545e45d012").and_return(0)
      mod.check
    end
  end

  context "rails check" do
    before do
      Checker::Options.stub(:use_rails_for_sass).and_return(true)
    end

    after do
      `rm -rf spec/assets/stylesheets/checker-cache*`
    end

    it "runs rails check if preconditions_for_rails are met" do
      files = ["a.sass"]
      mod = Checker::Modules::Sass.new(files)
      mod.stub(:preconditions_for_rails?).and_return(true)
      mod.stub(:rails_project?).and_return(true)
      mod.stub(:rails_with_ap?).and_return(true)
      mod.stub(:check_for_executable).and_return(true)
      mod.stub(:stylesheets_dir).and_return("spec/assets/stylesheets/")
      mod.should_receive(:rails_check).and_return(Checker::Result.result(mod, 0))
      mod.check
    end

    it "runs normal check if preconditions_for_rails aren't met" do
      files = ["a.sass"]
      mod = Checker::Modules::Sass.new(files)
      mod.stub(:preconditions_for_rails?).and_return(false)
      mod.stub(:rails_project?).and_return(true)
      mod.stub(:rails_with_ap?).and_return(true)
      mod.stub(:check_for_executable).and_return(true)
      mod.stub(:stylesheets_dir).and_return("spec/assets/stylesheets/")
      mod.should_receive(:normal_check).and_return(Checker::Result.result(mod, 0))
      mod.check
    end

    it "gives proper command to sass module while checking .sass files" do
      files = ["a.sass"]
      mod = Checker::Modules::Sass.new(files)
      mod.stub(:preconditions_for_rails?).and_return(true)
      mod.stub(:rails_project?).and_return(true)
      mod.stub(:rails_with_ap?).and_return(true)
      mod.stub(:check_for_executable).and_return(true)
      mod.stub(:stylesheets_dir).and_return("spec/assets/stylesheets/")
      mod.should_receive(:plain_command).with("rails runner \"Rails.application.assets.find_asset(\\\"#{Dir.pwd}/spec/assets/stylesheets/checker-cachea.sass\\\").to_s\"").and_return(0)
      mod.check
    end

    it "gives proper command to sass module while checking .scss files" do
      files = ["a.scss"]
      mod = Checker::Modules::Sass.new(files)
      mod.stub(:preconditions_for_rails?).and_return(true)
      mod.stub(:rails_project?).and_return(true)
      mod.stub(:rails_with_ap?).and_return(true)
      mod.stub(:check_for_executable).and_return(true)
      mod.stub(:stylesheets_dir).and_return("spec/assets/stylesheets/")
      mod.should_receive(:plain_command).with("rails runner \"Rails.application.assets.find_asset(\\\"#{Dir.pwd}/spec/assets/stylesheets/checker-cachea.scss\\\").to_s\"").and_return(0)
      mod.check
    end
  end
end
