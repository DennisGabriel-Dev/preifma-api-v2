require "test_helper"

class DailyOffensiveResetJobTest < ActiveJob::TestCase
  def setup
    @user1 = users(:one)
    @user2 = users(:two)
  end

  test "resets streak for users who haven't had offensive activity for more than one day" do
    @user1.update_column(:current_streak, 5)
    @user1.update_column(:last_offensive_at, 3.days.ago.beginning_of_day)

    puts "Before job: user1 streak = #{@user1.current_streak}, last_offensive_at = #{@user1.last_offensive_at.to_date}"
    puts "Time.zone.yesterday = #{Time.zone.yesterday}"
    puts "Comparison: #{@user1.last_offensive_at.to_date} < #{Time.zone.yesterday} = #{@user1.last_offensive_at.to_date < Time.zone.yesterday}"

    # Executar o job
    DailyOffensiveResetJob.perform_now

    # Verificar se os streaks foram resetados
    @user1.reload

    puts "After job: user1 streak = #{@user1.current_streak}"
    assert_equal 0, @user1.current_streak
  end

  test "does not reset streak for users who had offensive activity yesterday" do
    # Configurar usuário com atividade ofensiva ontem
    @user1.update_column(:current_streak, 5)
    @user1.update_column(:last_offensive_at, Time.zone.yesterday.beginning_of_day)

    # Executar o job
    DailyOffensiveResetJob.perform_now

    # Verificar se o streak não foi resetado
    @user1.reload
    assert_equal 5, @user1.current_streak
  end

  test "does not reset streak for users who had offensive activity today" do
    # Configurar usuário com atividade ofensiva hoje
    @user1.update_column(:current_streak, 5)
    @user1.update_column(:last_offensive_at, Time.zone.today.beginning_of_day)

    # Executar o job
    DailyOffensiveResetJob.perform_now

    # Verificar se o streak não foi resetado
    @user1.reload
    assert_equal 5, @user1.current_streak
  end

  test "handles users with no offensive activity gracefully" do
    # Configurar usuário sem atividade ofensiva
    @user1.update_column(:current_streak, 0)
    @user1.update_column(:last_offensive_at, nil)

    # Executar o job (não deve gerar erro)
    assert_nothing_raised do
      DailyOffensiveResetJob.perform_now
    end
  end
end
