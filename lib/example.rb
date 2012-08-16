require_relative 'dbpedia_concept_search'

search = DbpediaConceptSearch.new('person', 'Yukihiro Matsumoto ')

puts "\nLabels for each result:"
puts "======================="
search.results.each{|result| puts "\t#{result.label}"}


puts "\nDetails of first result"
puts "======================="

one = search.results.first
puts " Label = #{one.label}"
puts one.description
puts " URI = #{one.uri}"

puts " With Classes"
one.classes.each do |klass|
  puts "   URI = #{klass.uri}"
end

puts " and Caterogies"
one.categories.each do |category|
  puts "   #{category.label}"
end

