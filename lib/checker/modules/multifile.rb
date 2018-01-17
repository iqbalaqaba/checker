module Checker
  module Modules
    class Multifile < Base
      def check_all_files
        gather_result :total
        color "  Checking #{files_to_check.join(", ")}...", :yellow
        result = check_all(files_to_check)
        show_status result.status
        gather_result result.status
        flush_and_forget_output result.status
        @results = [result.success?]
        after_check
      end
    end
  end
end
