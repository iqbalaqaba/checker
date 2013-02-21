module Checker
  module Results
    class Javascript < Default
      def success?
        case exitstatus
        when 0 then true
        when 1 then
          Checker::Options.prevent_commit_on_warning ? false : true
        else
          false
        end
      end

      def status
        case exitstatus
        when 0 then :ok
        when 1 then :warning
        else
          :fail
        end
      end
    end
  end
end
