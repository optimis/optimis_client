module OptimisClient

  class ResponseError < StandardError
    attr_accessor :status, :message, :errors
    
    def initialize(http_status, message=nil, errors = {})
      self.status, self.message, self.errors = http_status, message, errors
    end
  end
  
  class Base
    
    DEFAULT_TIMEOUT = 10*1000 # 10s

    @@hydra = Typhoeus::Hydra.new
    
    class << self
      attr_accessor :host, :secure, :api_key, :timeout
        
      def hydra
        @@hydra
      end
      
      def stubbed?
        !!@stubbed
      end
      
      def stubbed=(value)
        @stubbed = value
      end
            
      def secure=(value, disable_ssl_peer_verification = true)
        if value && !(Typhoeus::Easy.new.curl_version =~ /OpenSSL/)
          raise "Your libcurl SSL support not enabled." 
        end
        @secure = value
        @disable_ssl_peer_verification = disable_ssl_peer_verification
      end
                  
      def http_protocol
        (self.secure)? "https://" : "http://"
      end
      
      def hydra_run_all
        self.hydra.run unless self.stubbed?
      end

      protected

      def new_request(url, options={})
        options = { :disable_ssl_peer_verification => @disable_ssl_peer_verification, 
                    :timeout => (@timeout || DEFAULT_TIMEOUT) }.merge(options)
         
        options[:params] ||= {}           
        options[:params].merge!( :api_key => self.api_key ) unless options[:params][:api_key]
                             
        options[:headers] ||= {}
        options[:headers].merge!( "Authorization" => self.api_key ) unless options[:headers][:api_key]
         
        Typhoeus::Request.new(url, options)
      end
      
      def parse_json(response)
        begin
          Yajl::Parser.parse(response.body)
        rescue
          raise ResponseError.new( 502, "Parsing service JSON error: #{response.body}")
        end
      end
      
      def hydra_run(request)   
        self.hydra.queue(request)
        self.hydra.run
        response = request.response

        if response.timed_out?
          # response.curl_return_code => 28
          # http://curl.haxx.se/libcurl/c/libcurl-errors.html
          raise ResponseError.new( 504, "Service Timeout")
        else
          return response
        end
      end
            
    end
  end
  
end