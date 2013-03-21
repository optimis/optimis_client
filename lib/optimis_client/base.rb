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
        options = merge_default_options(options)
        if options[:params]
          options[:params] = fix_array_param_keys(options[:params])
        end
        Typhoeus::Request.new(url, options)
      end

      def fix_array_param_keys(params)
        fixed_params = {}
        params.each do |key, value|
          if Array === value
            fixed_params.store("#{key}[]", value)
          else
            fixed_params.store(key, value)
          end
        end
        fixed_params
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

      def merge_default_options(options = {})
        options = { :disable_ssl_peer_verification => @disable_ssl_peer_verification,
                    :timeout                       => (@timeout || DEFAULT_TIMEOUT) }.merge(options)
        options[:headers] ||= {}
        options[:headers].merge!('Authorization' => self.api_key) unless options[:headers][:api_key]
        options
      end
    end
  end
end
