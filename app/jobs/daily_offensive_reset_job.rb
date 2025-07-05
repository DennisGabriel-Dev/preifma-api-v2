class DailyOffensiveResetJob < ApplicationJob
  queue_as :default

  def perform
    log_file = Rails.root.join('log', 'daily_offensive_reset.log')
    job_logger = ActiveSupport::Logger.new(log_file, 'daily')
    job_logger.formatter = ActiveSupport::Logger::SimpleFormatter.new

    job_logger.info "=" * 50
    job_logger.info "DAILY OFFENSIVE RESET JOB STARTED"
    job_logger.info "Time: #{Time.current}"
    job_logger.info "Timezone: #{Time.zone.name}"
    job_logger.info "=" * 50

    users_with_offensive_activity = User.where.not(last_offensive_at: nil)
    total_users = users_with_offensive_activity.count
    reset_count = 0
    kept_count = 0

    job_logger.info "Found #{total_users} users with offensive activity"

    users_with_offensive_activity.find_each do |user|
      begin
        # Verificar se o usuário passou um dia completo sem responder
        # Resetar apenas se a última atividade foi antes de ontem
        job_logger.info "Processing user #{user.id} (#{user.email}): last_offensive_at=#{user.last_offensive_at.to_date}, yesterday=#{Time.zone.yesterday}"

        if user.last_offensive_at.to_date < Time.zone.yesterday
          job_logger.info "RESET: User #{user.id} (#{user.email}) - streak from #{user.current_streak} to 0"
          user.update_column(:current_streak, 0)
          reset_count += 1
        else
          job_logger.info "KEEP: User #{user.id} (#{user.email}) - streak remains #{user.current_streak}"
          kept_count += 1
        end
      rescue => e
        job_logger.error "ERROR: Processing user #{user.id}: #{e.message}"
        job_logger.error e.backtrace.join("\n")
      end
    end
  end
end
