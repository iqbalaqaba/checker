require 'yaml'

module Checker
  module Modules
    class Yaml < Base
      extensions 'yaml', 'yml'
      private
      def check_one(file, opts = {})
        ret = begin
          YAML.load_file(file)
          Checker::Result.result(self, 0)
        rescue Exception => e
          puts e
          Checker::Result.result(self, 1)
        end
      end
    end
  end
end
