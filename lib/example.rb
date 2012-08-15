require_relative 'dbpedia_concept_search'

search = DbpediaConceptSearch.new('person', 'Rooney')

search.results.each{|result| puts result.label}


#TODO get classes working more neatly



