$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'dbpedia_concept_search'

TEST_DATA = <<EOF
<ArrayOfResult xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://lookup.dbpedia.org/">
  <Result>
    <Label>Robert Redford</Label>
    <URI>http://dbpedia.org/resource/Robert_Redford</URI>
    <Description>
      Stuff about Robert Redford
    </Description>
    <Classes>
      <Class>
        <Label>actor</Label>
        <URI>http://dbpedia.org/ontology/Actor</URI>
      </Class>
    </Classes>
  </Result>
</ArrayOfResult>      
EOF

class DbpediaConceptSearch
  # Monkey patch xml so that class can be tested without calling remote server
  def xml
    TEST_DATA
  end
end

class DbpediaConceptSearchTest < Test::Unit::TestCase
  
  def setup
    @query_class = 'person'
    @query_string = 'Robert Redford'
    @cleaned_query_string = 'Robert%20Redford'
    @search = DbpediaConceptSearch.new(@query_class, @query_string)
  end

  def test_monkey_patch
    assert_equal(TEST_DATA, @search.xml)
  end
  
  def test_hash_from_xml
    assert_equal(Hash, @search.hash_from_xml.class)
    assert(@search.hash_from_xml.keys.include?('ArrayOfResult'), "hash keys should include 'ArrayOfResult'")
  end
  
  def test_cleaned_query_string
    assert_equal(@cleaned_query_string, @search.cleaned_query_string)
  end
  
  def test_dbpedia_url
    url = "http://lookup.dbpedia.org/api/search.asmx/KeywordSearch?QueryClass=#{@query_class}&QueryString=#{@cleaned_query_string}"
    assert_equal(url, @search.dbpedia_url)
  end
  
  def test_downcase_hash
    input = {'This' => 1, 'that' => 2, 'and' => {'The' => 3, 'other' => 4}}
    expected = {'this' => 1, 'that' => 2, 'and' => {'the' => 3, 'other' => 4}}
    assert_equal(expected, @search.downcase_hash(input))
  end
  
  def test_results
    result = @search.results.first
    assert_equal('http://dbpedia.org/resource/Robert_Redford', result.uri)
  end
  
  def test_to_json
    assert(/^\[\{\"Label\"\:\"Robert\sRedford\"/ =~ @search.to_json)
  end
  
end
