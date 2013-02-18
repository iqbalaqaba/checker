module Checker
  module Modules
    class Conflict < Base

      private
      def check_one(file, opts = {})
        status = [check_for_conflict_start(file), check_for_conflict_end(file)].all_true?
        {:exitstatus => 0, :success => status}
      end

      def check_for_conflict_start(file)
        !plain_command("grep -n \"<<<<<<< \" #{file}", :bundler => false, :return_boolean => true)
      end

      def check_for_conflict_end(file)
        !plain_command("grep -n \">>>>>>> \" #{file}", :bundler => false, :return_boolean => true)
      end
    end
  end
end
