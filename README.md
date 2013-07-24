Links in Common w/ Mozscape API
-------------------------------

Links in Common is a command line tool that makes use of [Mozscape API](https://github.com/seomoz/SEOmozAPISamples) requests. It attempts to emulate (crudely) the most basic functionality of Moz's Link Intersect Tool, which affords users the ability to track down links that two or more web properties have in common. At this juncture, Links in Common functions to compare just two subdomains.

### Usage

To use Links in Common, simply enter your Mozscape API credentials and run `ruby links_in_common.rb www.domain1.com www.domain2.com` from the apposite directory, where `www.domain1.com` and `www.domain2.com` are the subdomains whose top links you'd like to compare. Creating an alias (e.g., `lic`) to execute this file from any working directory isn't a bad idea.

