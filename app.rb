#
# catapeli
# A movie catalog
# v0.0.1
#

require 'sinatra'
require 'json'
require 'rest_client'

get '/' do
  content_type :json
  { message: 'welcome to catapeli' }.to_json
end

not_found do
  content_type :json
  halt 404, { error: 'URL not found' }.to_json
end
