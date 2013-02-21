module Checker
  module Modules
    class Slim < Base
      extensions 'slim'
      private
      def check_one(file, opts = {})
        Checker::Result.result(self, plain_command("slimrb --compile #{file} >> /dev/null"))
      end

      def check_for_executable
        silent_command("slimrb -v")
      end

      def dependency_message
        str = "Executable not found\n"
        str << "Install slim from rubygems: 'gem install slim'\n"
        str
      end
    end
  end
end
