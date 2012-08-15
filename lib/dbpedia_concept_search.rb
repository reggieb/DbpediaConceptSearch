require 'typhoeus'
require 'nori'
require 'hashie'
require 'json'

class DbpediaConceptSearch
  attr_reader :query_class, :query_string
  
  def initialize(query_class, query_string)
    @query_class = query_class
    @query_string = query_string
  end
  
  def dbpedia_url
    %Q{http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryClass=#{query_class}&QueryString=#{cleaned_query_string}}
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
    hash_results_array.compact.collect{|result| Hashie::Mash.new(downcase_hash(result))}
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
  
  def hash_from_xml
    @hash ||= Nori.parse(xml)
  end
  
  def to_json
    hash_results_array.compact.to_json
  end
  
  private  
  def hash_results
    hash_from_xml['ArrayOfResult']['Result']
  end
  
  def hash_results_array
    hash_results.kind_of?(Array) ? hash_results : [hash_results]
  end
  
end
