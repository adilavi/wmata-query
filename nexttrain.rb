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
# Output:       A text indicating how many mins are left until the next trainLine is arriving to the station
#
# Author : Adi Lavi
# Version 1.0
# Date : 2/22/2015

require 'net/http'
require 'json'

ApiKey = 'kfgpmgvfgacx98de9q3xazww'

# help method to display command line argument options
def help
    puts "Nexttrain takes up to 2 arguments:"
    puts "Train line - 1st argument, Options are : RD,BL,YL,GR,SV,OR. OR is set by default."
    puts "Staion name - 2nd argument, Options : http://www.wmata.com/rail/stations.cfm?rail=or. Ballston-MU is set by default."
    exit
end


# set the train line
if ARGV[0].nil?
    LineCode = "OR"
elsif ARGV[0]== "help"
    help
else LineCode = ARGV[0].upcase
end

# set the station
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


# Extracing the data out of the HTTP responde
result_hash = JSON.parse(response.body)
result_hash.each do |key, ary|
    if h=ary.find {|h| h['Line']==LineCode && h['LocationName']==StationName}
        puts "The next #{LineCode} train arriving to #{StationName} station is in #{h[RequestParam]} min(s)"
    else
        puts "Currently, No #{LineCode} train is registered to arrive to #{StationName} station. Try again later."
    end
end
