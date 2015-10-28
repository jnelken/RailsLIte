require_relative '../phase3/controller_base'
require_relative './session'
require 'byebug'

module Phase4
  class ControllerBase < Phase3::ControllerBase

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@req)
    end

    def redirect_to(url)
      super(url)
      session.store_session(@res)
    end

    def render_content(content, content_type)
      super(content, content_type)
      session.store_session(@res)
    end
  end
end
