module Checker
  module Results
    class ConsoleLog < Default
      def success?
        (Checker::Options.prevent_commit_on_warning && exitstatus == 0) ? false : true
      end

      def status
        exitstatus == 1 ? :ok : :warning
      end
    end
  end
end
