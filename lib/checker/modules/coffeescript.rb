module Checker
  module Modules
    class Coffeescript < Base
      extensions 'coffee'
      private
      def check_one(file)
        plain_command("cat #{file} | egrep -v '^//=' | coffee -sc > /dev/null")
      end

      def check_for_executable
        command('coffee -v', :show_output => false, :append => ">> /dev/null 2>&1")
      end

      def dependency_message
        str = "Executable not found\n"
        str << "Install coffeescript from npm: 'npm install -g coffee-script'\n"
        str << "More info: https://github.com/jashkenas/coffee-script/\n"
        str
      end
    end
  end
end
