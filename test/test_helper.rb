if ENV["COVERAGE"]
  # Roda depois do SimpleCov gravar os relatórios (at_exit é LIFO).
  at_exit do
    coverage_dir = File.expand_path("../coverage", __dir__)
    project_root = "#{File.expand_path('..', __dir__)}/"

    lcov = File.join(coverage_dir, "lcov.info")
    if File.exist?(lcov)
      File.write(lcov, File.read(lcov).gsub(/^SF:\.\//, "SF:"))
    end

    json = File.join(coverage_dir, "coverage.json")
    if File.exist?(json)
      require "json"
      data = JSON.parse(File.read(json))
      data["coverage"] = data.fetch("coverage", {}).transform_keys do |path|
        path.delete_prefix(project_root).delete_prefix("./")
      end
      File.write(json, JSON.pretty_generate(data))
    end
  end

  require "simplecov"
  require "simplecov-lcov"
  require "simplecov_json_formatter"

  SimpleCov::Formatter::LcovFormatter.config do |config|
    config.report_with_single_file = true
    config.single_report_path = "coverage/lcov.info"
  end

  SimpleCov.start "rails" do
    add_filter "/test/"
    formatter SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::LcovFormatter,
      SimpleCov::Formatter::JSONFormatter
    ])
  end
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # SimpleCov não funciona bem com workers paralelos sem collation
    parallelize(workers: :number_of_processors) unless ENV["COVERAGE"]

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
