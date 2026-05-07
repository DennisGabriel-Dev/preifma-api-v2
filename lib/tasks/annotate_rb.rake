# This rake task was added by annotate_rb gem.

# Can set `ANNOTATERB_SKIP_ON_DB_TASKS` to be anything to skip this
if Rails.env.development? && ENV["ANNOTATERB_SKIP_ON_DB_TASKS"].nil?
  begin
    require "annotate_rb"
    AnnotateRb::Core.load_rake_tasks
  rescue LoadError
    # Ignore when development gems are not installed (e.g., production-style Docker image).
  end
end
