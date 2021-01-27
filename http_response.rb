module MyServer
  class HTTPresponse
    def initialize(parsed_req)
      @parsed_req = parsed_req
    end

    def parse
      prepare(@parsed_req)
    end

    def prepare(parsed_req)
      path = parsed_req[:path]
      if path == "/"
        respond_with("index.html")
      else
        respond_with(".#{path}")
      end
    end

    def respond_with(path)
      if File.exists?(path)
        ok_response(File.binread(path))
      else
        error_response
      end
    end

    def ok_response(body)
      MyServer::Response.new(code: 200, body: body)
    end

    def error_response
      MyServer::Response.new(code: 404)
    end
  end

  class Response
    def initialize(code:, body: "")
      @response =
        "HTTP/1.1 #{code}\r\n" +
        "Content-Length: #{body.size}\r\n" +
        "\r\n" +
        "#{body}\r\n"
    end

    def send(session)
      session.write(@response)
    end
  end
end
