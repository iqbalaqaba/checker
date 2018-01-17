module Checker
  class Options
    class << self
      def get_config(conf, default = nil)
        config = `git config checker.#{conf}`.chomp
        config.empty? && !default.nil? ? default : config
      end

      def modules_to_check
        get_config("check", "all").split(",").map(&:strip)
      end

      def prevent_commit_on_warning
        get_config("commit-on-warning", "true") == "false"
      end

      def use_rails_for_sass
        get_config("rails-for-sass", "true") == "true"
      end
    end
  end
end
