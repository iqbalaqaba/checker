module Checker
  module Modules
    class Javascript < Base
      extensions "js"

      private

      def check_one(file, _opts = {})
        Checker::Result.result(self, plain_command("jsl -process #{file}"))
      end

      def check_for_executable
        silent_command("jsl -help:conf", bundler: false)
      end

      def dependency_message
        str = "Executable not found\n"
        str << "Install jsl linter binary\n"
        str << "More info: http://www.javascriptlint.com/download.htm\n"
        str
      end

      def show_status(status)
        if status == :ok
          print_success_message
        elsif status == :warning
          print_warning_message
        else
          print_fail_message
        end
      end
    end
  end
end
