require 'uri'
require 'net/http'
require 'open-uri'

class LatestNewsScraper
  BASE_URL = 'https://www.health.govt.nz'
  URL = "#{BASE_URL}/news-media/news-items"

  class Data < Struct.new(:date, :num_community_cases, :num_canterbury_cases, :href, keyword_init: true); end

  def call
    Data.new(
      date: date,
      num_community_cases: num_community_cases,
      num_canterbury_cases: num_canterbury_cases,
      href: href,
    )
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

  def index_doc
    @index_doc ||= Nokogiri.HTML(response.body)
  end

  def details_doc
    @details_doc ||= Nokogiri.HTML(URI.open(href))
  end

  def latest_row
    index_doc.css('.item-list ul .views-row').first
  end

  def date
    Date.parse(latest_row.css('.views-field-field-published-date').text.strip)
  end

  def title
    latest_row.css('.views-field-title').text.strip
  end

  def num_community_cases
    match_data = /([?:\d,]+) community cases/.match(title)
    match_data[1]&.gsub(',', '').to_i
  end

  def href
    anchor = latest_row.css('.views-field-title a')
    path = anchor.attribute('href').value
    "#{BASE_URL}#{path}"
  end

  def full_details_text
    details_doc.css('.field-name-body').text
  end

  def location_of_new_community_cases
    match_data = full_details_text.match /(Location of new community cases.*)/
    match_data&.[](1)
  end

  def num_canterbury_cases
    return nil unless location_of_new_community_cases.present?

    match_data = location_of_new_community_cases.match(/Canterbury \(([?:\d,]+)\)/)
    match_data[1]&.gsub(',', '').to_i
  rescue nil
  end
end
