module Checker
  module Modules
    class Haml < Base
      extensions "haml"

      private

      def check_one(file, _opts = {})
        Checker::Result.result(self, plain_command("haml --check #{file} >> /dev/null"))
      end

      def check_for_executable
        silent_command("haml -v")
      end

      def dependency_message
        str = "Executable not found\n"
        str << "Install haml from rubygems: 'gem install haml'\n"
        str
      end
    end
  end
end
