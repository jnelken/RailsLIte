require "byebug"

module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern, @http_method, @controller_class, @action_name = pattern, http_method, controller_class, action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      self.pattern =~ req.path && self.http_method == req.request_method.downcase.to_sym
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      @route_params = {}
      match_data = @pattern.match(req.path)
      controller = @controller_class.new(req, res, {})

      i = 0
      while i < match_data.length
        @route_params[i] = match_data[i]   # not complete : (
        i+=1
      end

      controller.invoke_action(@action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      self.instance_eval(&proc)
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
        define_method(http_method) do |pattern, controller_class, action_name|
          add_route(pattern, http_method, controller_class, action_name)
        end
    end

    # should return the route that matches this request
    def match(req)
      @routes.each do |rte|
        return rte if rte.matches?(req)
      end

      nil
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      if @routes.none? {|route| route == req}
        res.status = 404
        res.body = "incorrect path"
      end
    end

  end
end
