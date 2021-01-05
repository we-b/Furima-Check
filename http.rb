# httpリクエストの実行に必要なライブラリ
require "net/http"
require "json"


uri = URI.parse("https://jsonplaceholder.typicode.com/todos")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = uri.scheme === "https"

params = { name: "Takuya" }
headers = { "Content-Type" => "application/json" }
response = http.post(uri.path, params.to_json, headers)

puts response.code # status code
puts response.body # response body