require 'socket'
require 'json'
params = {}
server = TCPServer.open(2000)
loop do 
	Thread.start(server.accept) do |client|
		request = clien.read_nonblock(256)

		request_header, request_body = request.split("\r\n\r\n", 2)
		path = request_header.split[1][1..-1]
		method = request_header.split[0]

		if File.exist?(path)
			respond_body = File.read(path)
			client.puts "HTTP/1.1 200 OK\r\nContent-type:text/html\r\n\r\n"
			if method == "GET"
				client.puts respond_body
			elsif method == "POST"
				params << JSON.parse(request_body)
				user_data = "<li>name: #{params[:viking][:name]}</li><li>e-mail: #{params[:person][:email]}</li>"
				client.puts respond_body.gsub('<%= yield %>',user_data)
			end
		else 
			client.puts "HTTP/1.0 404 Not Found\r\n\r\n"
			client.puts "404 Error, File Could not be Found"
		end
		client.close
	end
end