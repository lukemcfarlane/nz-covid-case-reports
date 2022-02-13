class DailyReportSerializer < ActiveModel::Serializer
  attributes :date, :count, :reported_at

  def reported_at
    object.created_at
  end
end
