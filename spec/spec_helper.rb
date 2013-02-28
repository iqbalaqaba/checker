require 'digest/md5'
require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

FIXTURES_PATH = File.join(File.dirname(__FILE__), "checker", "fixtures")

def fixture(dir, filename)
  "#{FIXTURES_PATH}/#{dir}/#{filename}"
end

def digest filename
  Digest::MD5.hexdigest(filename)
end

require 'checker/cli'

module Checker
  module Modules
    class Base
      def checkout_file file_name, target
        `cp #{file_name} #{checkout_file_name(target)} > /dev/null 2>&1`
      end
    end
  end
end
