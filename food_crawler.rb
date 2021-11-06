require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
  url = "https://tastykitchen.vn/thuc-don"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  raw_items = parsed_page.css('div.item')
  
  items = Array.new
  raw_items.each do |item|
    if item.css('p.price').text=="" || item.css('img')[0].nil?
      next
    else
      item = {
        name: item.css('h3>a').text,
        price: item.css('p.price').text.gsub(' ₫','').gsub('.','').to_i,
        image_url: item.css('img')[0].attributes["data-src"].value
      }
    end
    items << item
    puts "Add #{item[:name]}"
    puts ""
  end
  byebug
end

scraper