require 'net/http'
require 'json'
require 'csv'

#GET DATA
base_uri = "http://api.nytimes.com/svc/search/v2/articlesearch.json?"
params = "sort=newest&begin_date=20100101&end_date=20120101"
api_key = "&api-key=INSERTKEYHERE"
page = "&page=1"

docs = []


(1..100).each do |i|
	sleep(0.3)
	page = "&page=#{i}"
	req = base_uri + params + page + api_key
	puts req
	response = JSON.parse( Net::HTTP.get(URI(req)) )
	res = response['response']
	docs << res['docs']
end
docs.flatten!

# => ["web_url", "snippet", "lead_paragraph", "abstract", "print_page",
#  "blog", "source", "multimedia", "headline", "keywords", "pub_date", 
#  "document_type", "news_desk", "section_name", "subsection_name", 
#  "byline", "type_of_material", "_id", "word_count"]

# JSON HASH TO CSV
csv = CSV.generate do |csv| 
	csv << docs.first.keys 
	docs.each do |doc|
			clean_headline = doc['headline']['main']
			doc['headline'] = clean_headline 
			csv << doc.values
	end
end


#WRITE TO FILE
File.open("2010_ny_1000_newest_clean.csv", "w+") do |io|
	io << csv
end
