require 'typhoeus'
require 'nori'
require 'hashie'
require 'json'

class DbpediaConceptSearch
  attr_reader :query_class, :query_string

  def self.hostname
    @hostname ||= 'lookup.dbpedia.org'
  end

  def self.hostname=(hostname)
    @hostname = hostname
  end

  def initialize(query_class, query_string)
    @query_class = query_class
    @query_string = query_string
  end

  def dbpedia_url
    %Q{http://#{DbpediaConceptSearch.hostname}/api/search.asmx/KeywordSearch?QueryClass=#{query_class}&QueryString=#{cleaned_query_string}}
  end

  def cleaned_query_string
    query_string.gsub(/\s/, '%20')
  end

  def xml
    @xml ||= response.body
  end

  def response
    @response ||= Typhoeus::Request.get(dbpedia_url)
  end

  def results
    hash_results_array.compact.collect{|result| Hashie::Mash.new(processed_hash(result))}
  end

  def processed_hash(hash)
    hash = infanticide(hash)
    hash = downcase_hash(hash)
  end

  def downcase_hash(hash)
    if hash.kind_of? Hash
      hash.each_with_object({}) do |(k, v), h|
        h[k.downcase] = downcase_hash(v)
        h.delete(k) unless k == k.downcase
      end
    elsif hash.kind_of? Array
      hash.collect do |h|
        downcase_hash(h)
      end
    else
      return hash
    end
  end

  def infanticide(hash)
    if hash.kind_of?(Hash)
      hash = collapse_singular_child_into_plural_parent(hash)
      hash.each_with_object({}) do |(k, v), h|
        h[k] = infanticide(v)
      end

    end
    if hash.kind_of?(Array)
      hash.collect do |h|
        infanticide(h)
      end
    else
      return hash
    end
  end

  def hash_from_xml
    @hash ||= Nori.parse(xml)
  end

  def to_json
    processed_hash(hash_results_array.compact).to_json
  end

  def hash_results
    hash_from_xml['ArrayOfResult']['Result'] if hash_from_xml['ArrayOfResult']
  end

  def hash_results_array
    hash_results.kind_of?(Array) ? hash_results : [hash_results]
  end

  def collapse_singular_child_into_plural_parent(hash)
    parents = Hash.new
    hash.each do |key, value|
      if value.kind_of?(Hash) and Regexp.new("^#{value.keys.first.gsub(/y\s*$/, 'i')}(s|es)") =~ key
        parents[key] = value.values.first
      end
    end
    hash.merge(parents)
  end

end
