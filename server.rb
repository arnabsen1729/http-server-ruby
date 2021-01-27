require "socket"
# require "awesome_print"
require_relative "http_request"
require_relative "http_response"

port = (ARGV[0] || 8000).to_i

server = TCPServer.new("localhost", port)
puts "Server started at port: #{port}"

while (session = server.accept)
  parsed_request = MyServer::HTTPrequest.new(session.readpartial(2048)).parse
  puts parsed_request[:path]
  response = MyServer::HTTPresponse.new(parsed_request).parse
  response.send(session)
  session.close
end
