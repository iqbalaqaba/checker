module Checker
  module Modules
    class Pry < Base

      private
      def check_one(file, opts = {})
        status = [check_for_binding_pry(file), check_for_binding_remote_pry(file)].all_true?
        {:exitstatus => 0, :success => status}
      end

      def check_for_binding_pry(file)
        !plain_command("grep -n \"binding\\.pry\" #{file}", :bundler => false, :return_boolean => true)
      end

      def check_for_binding_remote_pry(file)
        !plain_command("grep -n \"binding\\.remote_pry\" #{file}", :bundler => false, :return_boolean => true)
      end
    end
  end
end
