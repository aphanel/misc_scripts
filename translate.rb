require 'net/http'
require 'json'
require 'uri'

params = ARGV

if params.length != 3
  raise("Wrong number of params, found #{params.length}, expected 3")
end

input = params[0]
output = 'output'
source = params[1]
target = params[2]

f = File.open(input, 'r')
res = File.open(output, 'a')

f.each_line do |line|
  phrase = line.tr("\n", '')
  base_uri = 'https://glosbe.com/gapi/'
  glosbe_uri = URI.parse(URI.escape("#{base_uri}translate?from=#{source}&dest=#{target}&format=json&phrase=#{phrase}&pretty=true"))
  https = Net::HTTP.new(glosbe_uri.host, glosbe_uri.port)
  https.use_ssl = true
  request = Net::HTTP::Get.new(glosbe_uri)
  request['Content-Type'] = 'application/x-www-form-urlencoded'
  response = https.request(request)
  json_response = JSON.parse(response.body)
  result = json_response.dig('tuc', 0, 'phrase', 'text')
  res << "#{phrase}\t#{result}\n"
  puts "ADDED : #{phrase}\t#{result}"
end

res.close
f.close
