module Checker
  class RVM
    class << self
      def rvm_command(command)
        rvm_gem = ENV["GEM_HOME"].to_s
        rvm_version = rvm_gem.gsub(/.+rvm\/gems\//, "")

        "#{rvm_shell} '#{rvm_version}' -c '#{command}'"
      end

      def rvm_shell
        File.join(ENV["rvm_path"].to_s, "bin/rvm-shell")
      end
    end
  end
end
