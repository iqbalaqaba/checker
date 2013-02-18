module Checker
  module Modules
    class Sass < Base
      extensions 'scss', 'sass'
      private
      def check_one(file, opts = {})
        if Checker::Options.use_rails_for_sass
          rails_check(file, opts)
        else
          normal_check(file, opts)
        end
      end

      def rails_check(file, opts)
        debug("Rails project detected") if rails_project?
        exitstatus = plain_command(%(rails runner "Rails.application.assets.find_asset(\\"#{Dir.pwd}/#{file}\\").to_s"))
        {:exitstatus => exitstatus, :success => (exitstatus == 0)}
      end

      def normal_check(file, opts)
        exitstatus = plain_command("sass #{"--scss" if opts[:extension] == ".scss"} -c #{file}")
        {:exitstatus => exitstatus, :success => (exitstatus == 0)}
      end

      def check_for_executable
        silent_command("sass -v")
      end

      def dependency_message
        str = "Executable not found\n"
        str << "Install sass from rubygems: 'gem install sass'\n"
        str << "Sass requires haml to work properly: 'gem install haml'\n"
        str
      end

      ## for rails project
      def checkout_file file_name, target
        debug("git show :0:#{file_name} > #{checkout_file_name(target)} 2>/dev/null")
        mkdir_if_necessary(checkout_file_name(target))
        `git show :0:#{file_name} > #{checkout_file_name(target)} 2>/dev/null`
      end

      def mkdir_if_necessary(target)
        dir = target.gsub(File.basename(target), '')
        create_dir(dir)
      end

      def create_dir(dir)
        debug("Creating dir #{dir}")
        Dir.mkdir(dir) unless File.exists?(dir)
      end

      def checkout_file_name target
        (Checker::Options.use_rails_for_sass && rails_with_ap?) ? "app/assets/stylesheets/checker-cache#{target}" : super
      end

      def proper_path file_name
        file_name.gsub(/app\/assets\/stylesheets\//, '')
      end

      def check_one_file file_name
        if (Checker::Options.use_rails_for_sass && rails_with_ap?)
          color " (using rails runner)... ", :blue
          debug(file_name)
          debug(proper_path(file_name))
          checkout_file(file_name, proper_path(file_name))
          check_one(checkout_file_name(proper_path(file_name)), :extension => File.extname(file_name))
        else
          super
        end
      end
    end
  end
end
