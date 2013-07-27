require 'openssl'
require 'base64'
require 'cgi'
require 'open-uri'
require 'json'

# You can obtain you access id and secret key here: http://www.seomoz.org/api/keys
ACCESS_ID	= ENV["MOZ_ACCESS_ID"]
SECRET_KEY	= ENV["MOZ_SECRET_KEY"]

# Set your expires for several minutes into the future.
# Values excessively far in the future will not be honored by the Mozscape API.
expires	= Time.now.to_i + 300

# A new linefeed is necessary between your AccessID and Expires.
string_to_sign = "#{ACCESS_ID}\n#{expires}"

# Get the "raw" or binary output of the hmac hash.
binary_signature = OpenSSL::HMAC.digest('sha1', SECRET_KEY, string_to_sign)

# We need to base64-encode it and then url-encode that.
URL_SAFE_SIGNATURE = CGI::escape(Base64.encode64(binary_signature).chomp)

source_cols = "4"
target_cols = "4"
link_cols		= "0"
scope = "page_to_subdomain"
sort = "page_authority"
filter = "external+follow"
limit = "100"

target_domains = []
link_profiles = []

# Put domains being compared into array
ARGV.each { |domain| target_domains << URI::encode(domain) }

# Base URL for requesting link metrics
request_base = "http://lsapi.seomoz.com/linkscape/links/"

# Now put your entire request query string together
request_query_string = "?SourceCols=#{source_cols}&TargetCols=#{target_cols}&LinkCols=#{link_cols}&Scope=#{scope}&Sort=#{sort}&Filter=#{filter}&Limit=#{limit}&AccessID=#{ACCESS_ID}&Expires=#{expires}&Signature=#{URL_SAFE_SIGNATURE}"

target_domains.each do |target_domain|
	request_url = request_base + target_domain + request_query_string

	# Go and fetch the URL
	response = open(request_url).read

	# Push response into link profiles array
	link_profiles << JSON.parse(response)

	# Delay next request
	sleep(10)
end

# Create array to store common links
common_links = []

# Perform expensive check for common links
link_profiles.first.each do |domain_one_link|
	link_profiles.last.each do |domain_two_link|
		common_links << domain_one_link["uu"] if domain_one_link["uu"] == domain_two_link["uu"] && !common_links.include?(domain_one_link["uu"])
	end
end

# Output # of common links w/ URLs
puts
puts "You found #{common_links.size} common links."
puts
unless common_links.empty?
	common_links.each { |url| puts url }
	puts 
end

# Write common links to file if any are found
timestamp = Time.now.to_i
file_name = "common-links-#{timestamp}.txt"
file = File.open(file_name, "w") unless common_links.empty?
if file
	common_links.each { |url| file.puts url }
	file.close
	puts "Common links saved in working directory: #{file_name}"
	puts
end