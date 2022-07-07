require 'vcr'

VCR.configure do |config|
  config.ignore_hosts '127.0.0.1', 'localhost'
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
