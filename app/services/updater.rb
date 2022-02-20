class Updater
  DAILY_UPDATE_DUE = ENV.fetch('DAILY_UPDATE_DUE', '1:00pm')

  def call
    return unless due? && !up_to_date?

    return unless latest_data.date.today?

    DailyReport.create!(
      date: latest_data.date,
      count: latest_data.num_community_cases,
      canterbury_count: latest_data.num_canterbury_cases,
      href: latest_data.href,
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
    puts notification_message

    notifier = IftttNotifier.new(
      notification_message,
      latest_data.href,
    )
    notifier.send
  end

  def notification_message
    "#{latest_data.num_community_cases} new cases today, #{latest_data.num_canterbury_cases} in Canterbury"
  end
end
