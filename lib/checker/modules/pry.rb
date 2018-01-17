module Checker
  module Modules
    class Pry < Base
      private

      def check_one(file, _opts = {})
        status = [check_for_binding_pry(file), check_for_binding_remote_pry(file)].all_true?
        Checker::Result.result(self, status ? 0 : 1)
      end

      def check_for_binding_pry(file)
        !plain_command("grep -n \"binding\\.pry\" #{file}", bundler: false, return_boolean: true, rvm: false)
      end

      def check_for_binding_remote_pry(file)
        !plain_command("grep -n \"binding\\.remote_pry\" #{file}", bundler: false, return_boolean: true, rvm: false)
      end
    end
  end
end
