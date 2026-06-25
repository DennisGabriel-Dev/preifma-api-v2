if ENV["COVERAGE"]
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
    add_filter "/spec/"
    formatter SimpleCov::Formatter::MultiFormatter.new([
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::LcovFormatter,
      SimpleCov::Formatter::JSONFormatter
    ])
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
