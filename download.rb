require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'HTTParty'

urls = IO.readlines("ted.txt").map {|line| line.chomp}
if !File.directory?("TOPvideo")
  Dir.mkdir("TOPvideo")
end

urls.each_with_index do |url, count|
  begin
   puts 'start '+ url
   doc = Nokogiri.parse(open(url).read)
   video = doc.xpath("//div/p/a[text()='download the video']").attribute("href").to_s
   visub = doc.xpath("//div/a[text()='Order DVD']").attribute("href").to_s.split("=")[1]
   puts "#{video}"
   videoName = "TOPvideo\\" + url.match(/http:\/\/www.ted.com\/talks\/(.*)\.html/i)[1] + ".mp4"
   videoSubsRU = "TOPvideo\\" + url.match(/http:\/\/www.ted.com\/talks\/(.*)\.html/i)[1] + "RU.srt"
   videoSubsEN = "TOPvideo\\" + url.match(/http:\/\/www.ted.com\/talks\/(.*)\.html/i)[1] + "EN.srt"
   if !File.file?(videoName)

  # response = HTTParty.get(video)

   File.open( videoName, "wb") do |f|
      f <<  HTTParty.get(video)
    end

   begin
   puts "subtitles"
   responseSubRU = HTTParty.get('http://www.ted.com/talks/subtitles/id/' +visub + '/lang/ru/format/srt')
   responseSubEN = HTTParty.get('http://www.ted.com/talks/subtitles/id/' +visub + '/lang/en/format/srt')
   puts "#{videoSubsRU}"
   puts "#{videoSubsEN}"

   File.open( videoSubsRU, "w+") do |f|
    f.write((responseSubRU.body))
   end
   File.open( videoSubsEN, "w+") do |f|
    f.write((responseSubEN.body))
   end
    rescue
   puts "Failed to download subtitles #{url}"
  end
  end

  rescue
   puts "Failed to download #{url}"
  end
end