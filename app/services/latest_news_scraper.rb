require 'uri'
require 'net/http'

class LatestNewsScraper
  URL = 'https://www.health.govt.nz/news-media/news-items'

  class Data < Struct.new(:date, :num_community_cases, keyword_init: true); end

  def call
    Data.new(date: date, num_community_cases: num_community_cases)
  end

  def self.call
    new.call
  end

  private

  def uri
    URI(URL)
  end

  def response
    @response ||= Net::HTTP.get_response(uri)
  end

  def doc
    @doc ||= Nokogiri.HTML(response.body)
  end

  def latest_row
    doc.css('.item-list ul .views-row').first
  end

  def date
    Date.parse(latest_row.css('.views-field-field-published-date').text.strip)
  end

  def title
    latest_row.css('.views-field-title').text.strip
  end

  def num_community_cases
    match_data = /(\d+) community cases/.match(title)
    match_data[1]&.to_i
  end
end
