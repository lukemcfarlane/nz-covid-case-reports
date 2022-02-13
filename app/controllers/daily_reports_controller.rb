class DailyReportsController < ApplicationController
  def index
    render json: daily_reports
  end

  def latest
    render json: daily_reports.first
  end

  private

  def daily_reports
    DailyReport.order(created_at: :desc)
  end
end
