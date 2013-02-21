module Checker
  class Result
    class << self
      def result(klass, exitstatus)
        debug klass
        debug exitstatus
        result_class(klass.classname).new(exitstatus)
      end

      def result_class(klass)
        "Checker::Results::#{klass}".constantize
      rescue NameError => e
        default_result_class
      end

      def default_result_class
        Checker::Results::Default
      end
    end
  end
end
