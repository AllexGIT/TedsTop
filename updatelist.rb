require 'rubygems'
require 'nokogiri'
require 'open-uri'

# output a file with the results
File.open("ted.txt", "w+") do |f|
(1..3).each do |page|

  # fetch ted talks from each page
  doc = Nokogiri.parse(open("http://www.ted.com/talks/list/page/#{page}/?orderedby=MOSTVIEWED").read)
 talks = doc.search('dd a').inject({})  do |hash,a|
    hash["http://www.ted.com#{a.attributes['href'].value}"] = a.attributes['title'].value
    hash
  end

   talks.keys.each do |url|
     f.write(url+"\n")
   end

 puts "processed page #{page}"
end

end
