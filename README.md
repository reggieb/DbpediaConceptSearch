DbpediaConceptSearch
====================

A tool that queries dbpedia.org's lookup tool to find concepts, and then
bundles the results into either ruby objects (using Hashie) or json.

Usage
-----

The initial search is defined by creating a new DbpediaConceptSearch:

    search = DbpediaConceptSearch.new('place', 'London')

This will lead to a query matching [this](http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryClass=place&QueryString=London)

Results
-------

The results method will return an array of objects. See lib/example.rb

JSON
----

Use search.to_json to return a JSON representation of the data.

