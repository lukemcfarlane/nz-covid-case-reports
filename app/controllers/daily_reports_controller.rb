class DailyReportsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :check_for_updates

  def index
    render json: daily_reports
  end

  def latest
    render json: daily_reports.first
  end

  def check_for_updates
    Updater.call
  end

  private

  def daily_reports
    DailyReport.order(created_at: :desc)
  end
end
