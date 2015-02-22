# Queries Washington Metropolitan Area Transit Authority for the next train arriving to a station
#
# Usage:        nexttrain trainLine station
#
# Arguments:    trainLine - Two-letter abbreviation for the line
#               Opttions :
#               RD - Red
#               BL - Blue
#               YL - Yellow
#               OR - Orange - Default line
#               GR - Green
#               SV - Silver
#
#               StationName - train station
#               Options : http://www.wmata.com/rail/stations.cfm?rail=or
#               default station is Ballston-MU
#
# Output:       A text indicating how many mins left until the next trainLine is arriving to the station
#
# Author : Adi Lavi
# Version 1.0
# Date : 2/20/2015

require 'net/http'
require 'json'

ApiKey = 'kfgpmgvfgacx98de9q3xazww'

# setting the train line
if ARGV[0].nil?
    LineCode = "OR"
else LineCode = ARGV[0]
end

# setting the station
if ARGV[1].nil?
    StationName = "Ballston-MU"
    else StationName = ARGV[1]
end


# Next Train time field
RequestParam = "Min"


# API call to get the next train's schedule
uri = URI('https://api.wmata.com/StationPrediction.svc/json/GetPrediction/All')
uri.query = URI.encode_www_form('api_key' => ApiKey)

request = Net::HTTP::Get.new(uri.request_uri)

response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == "https") do |http|
    http.request(request)
end


# Extracing the data out of the json stream
result_hash = JSON.parse(response.body)
result_hash.each do |key, ary|
    if h=ary.find {|h| h['Line']==LineCode && h['LocationName']==StationName}
        puts "The next #{LineCode} train arriving to #{StationName} station is in #{h[RequestParam]} min(s)"
    else
        puts "Currently, No train is registered to arrive. Try again later."
    end
end
