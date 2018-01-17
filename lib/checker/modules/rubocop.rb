module Checker
  module Modules
    class Rubocop < Multifile
      private

      def check_all(files, _opts = {})
        Checker::Result.result(self, plain_command("rubocop -f c #{files.join(' ')}", bundler: false))
      end

      def dependency_message
        str = "Executable not found\n"
        str << "Install rubocop using rubygems: 'gem install rubocop'"
        str
      end

      def fix_message(files)
        "\nTo Autocorrect, execute: rubocop -a #{files.join(' ')}\n"
      end

      def after_check
        puts fix_message(files_to_check).colorize(:green) if @results.first == false
      end
    end
  end
end
