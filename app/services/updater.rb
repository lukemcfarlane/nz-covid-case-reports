class Updater
  DAILY_UPDATE_DUE = ENV.fetch('DAILY_UPDATE_DUE', '1:00pm')

  def call
    return unless due? && !up_to_date?

    return unless latest_data.date.today?

    DailyReport.create!(
      date: latest_data.date, count: latest_data.num_community_cases
    )
    notify!
  end

  def self.call
    new.call
  end

  private

  def due?
    due_at = Time.parse(DAILY_UPDATE_DUE)
    Time.now.after?(due_at)
  end

  def up_to_date?
    DailyReport.maximum(:date) == Date.today
  end

  def latest_data
    @latest_data ||= LatestNewsScraper.call
  end

  def notify!
    notifier = IftttNotifier.new("Today's cases: #{latest_data.num_community_cases}")
    notifier.send
  end
end
