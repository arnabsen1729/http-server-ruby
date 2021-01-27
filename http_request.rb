module MyServer
  class HTTPrequest
    def initialize(request)
      @request = request
    end

    def normalize(header)
      header.tr(":", "").to_sym
    end

    def parse_headers(request)
      headers = {}
      request.lines[1..-1].each do |line|
        return headers if line == "\r\n"
        header, value = line.split
        header = normalize(header)
        headers[header] = value
      end
    end

    def parse
      method, path, version = @request.lines[0].split
      {
        method: method,
        version: version,
        path: path,
        headers: parse_headers(@request),
      }
    end
  end
end
