require 'rake/gempackagetask'

Gem::Specification.new do |s|
  s.name = 'dbpedia_concept_search'
  s.version = '0.1.0'
  s.authors = ['Rob Nichols']
  s.date = %q{2012-08-16}
  s.description = "A tool that queries dbpedia.org's lookup tool to find concepts, and then bundles the results into either ruby objects (using Hashie) or json."
  s.summary = "Dbpedia Concept Search queries dbpedia.org's lookup tool to find concepts"
  s.email = 'rob@undervale.co.uk'
  s.homepage = 'https://github.com/reggieb/DbpediaConceptSearch'
  s.files = ['README.md', 'LICENSE', FileList['lib/**/*.rb']].flatten
  s.add_runtime_dependency 'hashie', '~> 1.2.0'
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'nori'
  s.add_runtime_dependency 'typhoeus'
  s.require_path = "lib"
end