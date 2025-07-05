class DailyOffensiveResetJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info "Starting daily offensive reset job at #{Time.current}"

    users_with_offensive_activity = User.where.not(last_offensive_at: nil)

    users_with_offensive_activity.find_each do |user|
      begin
        # Verificar se o usuário passou um dia completo sem responder
        # Resetar apenas se a última atividade foi antes de ontem
        Rails.logger.info "Processing user #{user.id}: last_offensive_at=#{user.last_offensive_at.to_date}, yesterday=#{Time.zone.yesterday}"

        if user.last_offensive_at.to_date < Time.zone.yesterday
          Rails.logger.info "About to reset streak for user #{user.id} from #{user.current_streak} to 0"
          user.update_column(:current_streak, 0)
          Rails.logger.info "Reset streak for user #{user.id} (#{user.email}) - last activity: #{user.last_offensive_at.to_date}"
        else
          Rails.logger.info "Keeping streak for user #{user.id} (#{user.email}) - last activity: #{user.last_offensive_at.to_date}"
        end
      rescue => e
        Rails.logger.error "Error processing user #{user.id}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end

    Rails.logger.info "Completed daily offensive reset job at #{Time.current}"
  end
end
