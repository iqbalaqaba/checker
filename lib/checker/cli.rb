require 'checker'

module Checker
  class CLI
    class << self
      def execute
        if ARGV.size == 0
          modules = get_modules_to_check
        else
          if ARGV[0] == "install"
            Checker::Installator.install!
          elsif ARGV[0] == "reinstall"
            Checker::Installator.reinstall!
          elsif ARGV[0] == "help"
            Checker::Helper.show_help!
          elsif ARGV[0] == "modules"
            Checker::Helper.show_modules!(self.available_modules)
          else
            modules = ARGV.map(&:downcase)
          end
        end

        if modules.empty? || modules.include?('all')
          modules = available_modules
        end

        check_module_availability(modules) do |result|
          puts "Modules not available: #{result.join(", ")}.\n"
          puts "Available: all, #{available_modules.join(", ")}\n"
          puts "Check your git config checker.check\n"
          exit 1
        end

        module_instances = []
        files = modified_files
        modules.each do |mod|
          klass = "Checker::Modules::#{mod.classify}".constantize
          module_instances << klass.new(files.dup)
        end

        files_checked = module_instances.map(&:files_to_check).flatten.uniq
        puts "[ CHECKER #{Checker::VERSION} - #{files_checked.size} files ]".light_blue

        results = module_instances.map(&:check)
        show_full_status module_instances
        exit (results.all_true? ? 0 : 1)
      end

      protected
      def available_modules
        Checker::Modules.constants.map(&:to_s).map(&:underscore) - ['base']
      end

      def check_module_availability(modules)
        result = modules - available_modules
        unless result.empty?
          if block_given?
            yield(result)
          end
        end
      end

      def get_modules_to_check
        Checker::Options.modules_to_check
      end

      def modified_files
        @modified_files ||= `git status --porcelain | egrep "^(A|M|R).*" | awk ' { if ($3 == "->") print $4; else print $2 } '`.split
      end

      def show_full_status modules
        full_status = {:total => 0, :ok => 0, :warning => 0, :fail => 0}
        modules.each do |m|
          full_status = full_status.merge(m.full_results) { |k, v1, v2| v1 + v2 }
        end
        print "#{full_status[:total]} checks preformed, "
        print "#{full_status[:ok]} ok".green
        print ", "
        print "#{full_status[:warning]} warning".magenta
        print ", "
        puts "#{full_status[:fail]} fail".red
      end
    end
  end
end
