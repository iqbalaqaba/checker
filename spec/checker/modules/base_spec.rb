require 'spec_helper'

describe Checker::Modules::Base do
  describe "rvm_command method" do
    context "properly fetches the ruby version from the environment variables" do
      before do
        allow(ENV).to receive(:[]).with("rvm_path").and_return "/Users/test/.rvm"
      end

      it "uses no gemsets" do
        allow(ENV).to receive(:[]).with("GEM_HOME").and_return "/Users/test/.rvm/gems/some_ruby_version"

        expect(Checker::Modules::Base.new.send(:rvm_command, "test")).to eq "/Users/test/.rvm/bin/rvm-shell 'some_ruby_version' -c 'test'"
      end

      it "uses global gemset" do
        allow(ENV).to receive(:[]).with("GEM_HOME").and_return "/Users/test/.rvm/gems/some_ruby_version@global"

        expect(Checker::Modules::Base.new.send(:rvm_command, "test")).to eq "/Users/test/.rvm/bin/rvm-shell 'some_ruby_version@global' -c 'test'"
      end

      it "uses some other gemset" do
        allow(ENV).to receive(:[]).with("GEM_HOME").and_return "/Users/test/.rvm/gems/some_ruby_version@v2"

        expect(Checker::Modules::Base.new.send(:rvm_command, "test")).to eq "/Users/test/.rvm/bin/rvm-shell 'some_ruby_version@v2' -c 'test'"
      end
    end

    context "using different rvm_path (system-wide rvm)" do
      before do
        allow(ENV).to receive(:[]).with("rvm_path").and_return "/usr/lib/rvm"
      end

      it "uses no gemsets" do
        allow(ENV).to receive(:[]).with("GEM_HOME").and_return "/Users/test/.rvm/gems/some_ruby_version"

        expect(Checker::Modules::Base.new.send(:rvm_command, "test")).to eq "/usr/lib/rvm/bin/rvm-shell 'some_ruby_version' -c 'test'"
      end

      it "uses global gemset" do
        allow(ENV).to receive(:[]).with("GEM_HOME").and_return "/Users/test/.rvm/gems/some_ruby_version@global"

        expect(Checker::Modules::Base.new.send(:rvm_command, "test")).to eq "/usr/lib/rvm/bin/rvm-shell 'some_ruby_version@global' -c 'test'"
      end

      it "uses some other gemset" do
        allow(ENV).to receive(:[]).with("GEM_HOME").and_return "/Users/test/.rvm/gems/some_ruby_version@v2"

        expect(Checker::Modules::Base.new.send(:rvm_command, "test")).to eq "/usr/lib/rvm/bin/rvm-shell 'some_ruby_version@v2' -c 'test'"
      end
    end
  end
end
