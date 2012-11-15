require 'spec_helper'

describe OptimisClient::Base do

  before do
    OptimisClient::Base.host = 'service.optimis.local'
    OptimisClient::Base.api_key = '1234567890'
    OptimisClient::Base.secure = false
  end

  subject { OptimisClient::Base }

  describe "Setup HTTP protocol" do
    it "supports https" do
      lambda { OptimisClient::Base.secure = true }.should_not raise_error
    end
  end
end
