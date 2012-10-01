DbpediaConceptSearch
====================

A tool that queries dbpedia.org's lookup tool to find concepts, and then
bundles the results into either ruby objects (using Hashie) or json.

Installation
------------

    gem install 'dbpedia_concept_search'

or if using bundler, add this to your Gemfile:

    gem 'dbpedia_concept_search'


Usage
-----

The initial search is defined by creating a new DbpediaConceptSearch:

    require 'dbpedia_concept_search'

    search = DbpediaConceptSearch.new('place', 'London')

This will lead to a query matching [this](http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryClass=place&QueryString=London)

Results
-------

The results method will return an array of objects. See lib/example.rb

JSON
----

Use search.to_json to return a JSON representation of the data.

Background service
------------------

DbpediaConceptSearch relies on [the dbpedia lookup service](http://wiki.dbpedia.org/Lookup?show_files=1). 
To test this service, check that the flowing URL returns XML describing Berlin concepts:

http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryClass=place&QueryString=berlin

If you get a failure, I've found the best solution is to post the error to
dbpedia-discussion@lists.sourceforge.net.

