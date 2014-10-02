require 'socket'
require 'json'

host = 'localhost'     # The web server
port = 2000                          # Default HTTP port
path = "/index.html"                 # The file we want 
params = Hash.new {|hash,key| hash[key] = Hash.new}
input = ''
until input == 'GET' || input == 'POST'
	print 'What type of request do you want to submit [GET, POST]? '
	input = gets.chomp.upcase
end

if input == 'GET'
	# This is the HTTP request we send to fetch a file
	request = "GET #{path} HTTP/1.0\r\n\r\n"
else 
	print "Enter name: "
	name = gets.chomp
	print "Enter e-mail: "
	email = gets.chomp
	params[:viking][:name] = name
	params[:viking][:email] = email
	body = params.to_json

	request = "POST /thanks.html HTTP/1.0\r\nContent-Length: #{params.to_json.length}\r\n\r\n#{body}"
end

socket = TCPSocket.open(host,port)  # Connect to server
socket.print(request)               # Send request
response = socket.read              # Read complete response
# Split response at first blank line into headers and body
headers,body = response.split("\r\n\r\n", 2) 
puts ""
print body
socket.close       