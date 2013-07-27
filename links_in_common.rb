require 'openssl'
require 'base64'
require 'cgi'
require 'open-uri'
require 'json'

def get_link_urls_from_response(response)
	response.map { |link| link["uu"] }
end

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

# Set Link Metrics request parameters
source_cols = "4"
target_cols = "4"
link_cols		= "0"
scope = "page_to_subdomain"
sort = "page_authority"
filter = "external+follow"
limit = "150"

target_domains = []
responses = []

# Check for compare all option flag and store if present
option_flag = ARGV.pop if ARGV.size == 4

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

	# Push parsed response into link profiles array
	responses << JSON.parse(response)

	# Delay next request
	sleep(10)
end

# Create array to store link profiles
link_profiles = []

# Get URLs from each response
responses.each { |response| link_profiles << get_link_urls_from_response(response) }

# Find common links between latter two domains
common_links = link_profiles[1] & link_profiles[2]

# If -ca option is present, compare all; if not, subtract our domain's links
option_flag == "-ca" ? common_links &= link_profiles[0] : common_links -= link_profiles[0]

# Output possible link opportunities
puts
puts "You found #{common_links.size} common links."
puts
unless common_links.empty?
	common_links.each { |url| puts url }
	puts

	# Write common links to file if any are found
	timestamp = Time.now.to_i
	file_name = "common-links-#{timestamp}.txt"
	file = File.open(file_name, "w")
	common_links.each { |url| file.puts url }
	file.close
	puts "Common links saved in working directory: #{file_name}"
	puts
end