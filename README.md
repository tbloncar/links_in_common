Links in Common w/ Mozscape API
-------------------------------

Links in Common is a command line tool that makes use of [Mozscape API](https://github.com/seomoz/SEOmozAPISamples) requests. It attempts to emulate (crudely) the most basic functionality of Moz's Link Intersect Tool, which affords users the ability to track down links that two or more web properties have in common. At this juncture, Links in Common functions to compare just three subdomains.

### Using Links in Common

To use Links in Common, simply enter your Mozscape API credentials and run `ruby links_in_common.rb www.domain1.com www.domain2.com www.domain3.com` from the apposite directory, where `www.domain2.com` and `www.domain3.com` are the subdomains whose top links you'd like to compare, and `www.domain1.com` is your subdomain. Links in Common will return links that `www.domain2.com` and `www.domain3.com` have in common that do not appear in the list of links returned for `www.domain1.com` (presumably the domain for which you are prospecting). Creating an alias (e.g., `lic`) to execute this file from any working directory isn't a bad idea.

You can use the command flag `-ca` as the optional fourth argument (e.g., `ruby links_in_common.rb www.domain1.com www.domain2.com www.domain3.com -ca`) to find links that all three subdomains have in common.

### Output Forms

Output from Links in Common comes in two forms: a summary of the common links found (shell) and a .txt file with the same list. The output forms (as well as everything else) can be easily toggled.

