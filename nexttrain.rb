# Queries WMATA public API
# Outputs the time the next Orange link train is arriving at Ballston train station
# Author : Adi Lavi
# Version 1.0
# Date : 2/20/2015


require 'net/http'
require 'json'

ApiKey = 'kfgpmgvfgacx98de9q3xazww'
LineCode = "OR"                 # Orange Line
StationName = "Ballston-MU"     # Desired Station Name
RequestParam = "Min"            # Next Train time field


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
        puts "The next Orange line train is arriving to Ballston metro station in #{h[RequestParam]} min(s)"
    else
        puts "Currently, No train is registered to arrive. Try again later."
    end
end
