require 'curl'
require 'nokogiri'
require 'csv'

category = ARGV[0]
out_file_path = ARGV[1]

proxy_servers_list = [
      "95.53.254.194:55817",
      "80.90.88.147:45974",
      "37.17.169.103:33248",
      "5.172.10.177:50460",
      "113.161.197.179:32688",
      "192.140.91.133:54108"
]

url = "https://www.petsonic.com/#{category}/"

proxy_server = proxy_servers_list[rand(proxy_servers_list.count)]
http = Curl.get(url, {:x => proxy_server})

html = Nokogiri::HTML(http.body_str)
csv_file = CSV.open(out_file_path, "w+")
csv_file << ["Name", "Price", "Image URL"]

html.css('.ajax_block_product').each do |element|
  name = element.css('.product-name').attr('title')
  price = element.css('.price').map { |tag| tag.text.strip }.last
  imageUrl = element.css('.front-image').attr('src')

  csv_file << [name, price, imageUrl]
end

csv_file.close
