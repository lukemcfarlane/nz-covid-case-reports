class AddCanterburyCountToDailyReports < ActiveRecord::Migration[7.0]
  def change
    add_column :daily_reports, :canterbury_count, :integer
  end
end
