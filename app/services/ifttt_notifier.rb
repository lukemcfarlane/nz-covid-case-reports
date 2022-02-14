require 'uri'
require 'net/http'

class IftttNotifier
  KEY = ENV.fetch('IFTTT_KEY')
  EVENT_NAME = ENV.fetch('IFTTT_EVENT_NAME', 'notify')

  def initialize(message, url = nil)
    @message = message
    @url = url
  end

  def send
    http.request(request)
  end

  private

  attr_reader :message, :url

  def uri
    URI("https://maker.ifttt.com/trigger/#{EVENT_NAME}/with/key/#{KEY}")
  end

  def http
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http
  end

  def request
    request = Net::HTTP::Post.new(uri.path)
    request.body = { value1: message, value2: url }.to_json
    request['Content-Type'] = 'application/json'
    request
  end
end
