require "digest/md5"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

FIXTURES_PATH = File.join(File.dirname(__FILE__), "checker", "fixtures")

def fixture(dir, filename)
  "#{FIXTURES_PATH}/#{dir}/#{filename}"
end

def digest(filename)
  Digest::MD5.hexdigest(filename)
end

require "checker/cli"

RSpec.configure(&:raise_errors_for_deprecations!)
