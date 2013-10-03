module Checker
  module Modules
    class Rubocop < Base
      extensions 'rb'
      private
      def check_one(file, opts = {})
        Checker::Result.result(self, plain_command("rubocop #{file}", :bundler => false))
      end

      def dependency_message
        str = "Executable not found\n"
        str << "Install rubocop using rubygems: 'gem install rubocop'"
        str
      end
    end
  end
end
