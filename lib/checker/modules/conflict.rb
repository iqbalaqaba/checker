module Checker
  module Modules
    class Conflict < Base

      private
      def check_one(file, opts = {})
        status = [check_for_conflict_start(file), check_for_conflict_end(file)].all_true?
        Checker::Result.result(self, status ? 0 : 1)
      end

      def check_for_conflict_start(file)
        !plain_command("grep -n \"<<<<<<< \" #{file}", :bundler => false, :return_boolean => true, :rvm => false)
      end

      def check_for_conflict_end(file)
        !plain_command("grep -n \">>>>>>> \" #{file}", :bundler => false, :return_boolean => true, :rvm => false)
      end
    end
  end
end
