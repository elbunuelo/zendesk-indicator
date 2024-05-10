require 'faraday'
require 'faraday_middleware'
require 'hashie/mash'
require 'json'

zd =
  Faraday.new(
    url: "https://#{ENV['ZENDESK_SUBDOMAIN']}.zendesk.com/api/v2",
    headers: { 'Content-Type': 'application/json' }
  ) do |conn|
    conn.request :json
    conn.response :json
    conn.use FaradayMiddleware::Mashify
    conn.adapter Faraday.default_adapter
    conn.basic_auth(ENV['ZENDESK_EMAIL'], ENV['ZENDESK_PASSWORD'])
  end

group_response = zd.get("search?query=type:ticket group:#{ENV['ZENDESK_GROUP']} status:Open assignee:none")
me_response = zd.get('search?query=type:ticket status:Open assignee:me')

total_group = group_response.body['results'].count
total_me = me_response.body['results'].count

alert = total_group >= 8 ? '' : ''

puts " #{total_me}#{total_group} #{alert}"
