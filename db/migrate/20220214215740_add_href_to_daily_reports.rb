class AddHrefToDailyReports < ActiveRecord::Migration[7.0]
  def change
    add_column :daily_reports, :href, :string
  end
end
