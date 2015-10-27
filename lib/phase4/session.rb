require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash

    attr_reader :name, :value

    def initialize(req)
      cookie = req.cookies.find { |c| c.name == '_rails_lite_app' }

      unless cookie.nil?
        @data = JSON.parse(cookie.value)
      else
        @data = {}
      end
    end

    def [](key)
      @data[key]
    end

    def []=(key, val)
      @data[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new('_rails_lite_app', @data.to_json)
      res.cookies << cookie
    end
  end
end