# Optimis Client

a Ruby client library for Optimis Service

## Requirements

* typhoeus
* yajl-ruby

### typhoeus requires libcurl >= 7.19 with OpenSSL support

    wget http://curl.haxx.se/download/curl-7.21.6.tar.gz
    tar zxvf curl-7.21.6.tar.gz
    cd curl-7.21.6
    ./configure --with-ssl
    make
    make install
    gem install typhoeus

## Run Unit Test

	bundle exec rspec spec/lib
  
## Design Note

As a client library, it should support:

* Wrap typhoeus operation
* Secure connection
* Handle timeout
* Provide 'stubbed' option, it will stub return values if set true

It will not:

* Rescue exception, it will raise to application layer.
