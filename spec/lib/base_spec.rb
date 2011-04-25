require 'spec_helper'

describe OptimisClient::Base do

  before do
    OptimisClient::Base.host = 'service.optimis.local'
    OptimisClient::Base.hydra = Typhoeus::Hydra.new
    OptimisClient::Base.api_key = '1234567890'
    OptimisClient::Base.secure = false
  end

  subject { OptimisClient::Base }

  describe "Setup HTTP protocol" do

    it "supports https" do
      lambda { OptimisClient::Base.secure = true }.should_not raise_error
    end

    it "should raise error if your libcurl SSL support not enabled." do
      Typhoeus::Easy.stub!(:new).and_return(mock("", :curl_version => "libcurl/7.19.7 OpenXXX/0.9.8l zlib/1.2.3"))
      lambda { OptimisClient::Base.secure = true }.should raise_error(RuntimeError)
    end
  end

end
