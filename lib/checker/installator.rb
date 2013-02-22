module Checker
  class Installator
    def self.template
      dir = File.expand_path('../../..', __FILE__)
      temp = File.read(File.join(dir, "/templates/checker-prepare-commit-msg"))
      ERB.new(temp).result
    end

    def self.hooks_dir
      "#{Dir.pwd}/.git/hooks"
    end

    def self.check_hook!
      unless Dir.exist?(hooks_dir)
        puts "Git Hooks dir not found. Are you sure you are inside project with git?"
        exit 1
      end
    end

    def self.reinstall!
      check_hook!

      pre_commit = "#{hooks_dir}/prepare-commit-msg"
      if File.exists?(pre_commit)
        puts "Removing current git precommit hook..."
        File.delete(pre_commit)
      end

      install!
    end

    def self.install!
      check_hook!

      pre_commit = "#{hooks_dir}/prepare-commit-msg"
      if File.exist?(pre_commit)
        puts "Appending checker script to existing prepare-commit-msg hook..."
        begin
          open(pre_commit, 'a') do |f| 
            f.puts(self.template)
            f.chmod(0755)
          end
        rescue Exception => e
          puts "Couldn't append checker script: #{e.message}"
          exit 1
        end
        exit 0
      else
        tmp = self.template
        str = "#!/bin/bash \n #{tmp}"
        begin
          open(pre_commit, "w") do |f| 
            f.puts(str)
            f.chmod(0755)
          end
        rescue Exception => e
          puts "Couldn't write checker script: #{e.message}"
          exit 1
        end
        puts "Script installed!"
        exit 0
      end
    end
  end
end
