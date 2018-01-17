require "spec_helper"

module Checker
  module Modules
    class Bogus < Base
      extensions ".test"

      private

      def check_one(_file)
        true
      end

      def check_for_executable
        true
      end
    end
  end
end

describe Checker::CLI do
  context "running without arguments" do
    it "should run checks on modules from git config" do
      allow(ARGV).to receive(:empty?).and_return true
      expect(Checker::CLI).to receive(:get_modules_to_check).and_return(["bogus"])
      expect(Checker::CLI).to receive(:exit).with(0).and_return true
      Checker::CLI.execute
    end
  end

  context "running with argument" do
    it "should run check on modules from argument" do
      stub_const("ARGV", ["pry"])
      expect(Checker::CLI).not_to receive(:get_modules_to_check)
      expect(Checker::CLI).to receive(:exit).with(0).and_return true
      Checker::CLI.execute
    end
  end
end
