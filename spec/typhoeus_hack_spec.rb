require 'spec_helper'
require 'rack'

describe 'Typhoeus Hacked' do

  let(:content) do
    {
      'array' => ['1', 'one'],
      'hash'  => {'1' => 'one'},
      'person' => {
        'name' => 'Mary Jane',
        'measures' => ['165cm', '45kg']
      }
    }
  end

  it 'should generate Rack parser firendly query string' do
    request = Typhoeus::Request.new('example.com', :method => :get, :params => content)
    query_string = request.url.split('?').last
    expect(Rack::Utils.parse_nested_query(query_string)).to eq(content)
  end

  it 'should generate Rack parser firendly post body' do
    request = Typhoeus::Request.new('example.com', :method => :post, :body => content)
    post_body = request.encoded_body
    expect(Rack::Utils.parse_nested_query(post_body)).to eq(content)
  end
end
