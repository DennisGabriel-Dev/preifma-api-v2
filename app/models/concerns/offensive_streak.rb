module OffensiveStreak
  extend ActiveSupport::Concern

  def register_offensive!(today = Date.current)
    last_day = last_offensive_at&.to_date
    if last_day == today
      return
    end

    if last_day == today - 1
      self.current_streak += 1
    else
      self.current_streak = 1
    end

    self.last_offensive_at = Time.current
    save!
  end
end
