module Checker
  module Modules
    class ConsoleLog < Base
      extensions 'coffee', 'js'

      private
      def check_one(file, opts = {})
        Checker::Result.result(self, plain_command("grep -n \"console\\.log\" #{file}", :bundler => false, :rvm => false))
      end

      def show_status(status)
        if status == :ok
          print_success_message
        else
          print_warning_message
        end
      end
    end
  end
end
