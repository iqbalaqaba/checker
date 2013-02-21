module Checker
  module Results
    class Default < Struct.new(:exitstatus)
      def success?
        exitstatus == 0
      end

      def status
        exitstatus == 0 ? :ok : :fail
      end
    end
  end
end
