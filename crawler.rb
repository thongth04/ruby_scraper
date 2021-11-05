require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
  url = "https://www.phuclong.com.vn/category/thuc-uong"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  raw_items = parsed_page.css('a.item-wrapper')
  
  items = Array.new
  raw_items.each do |item|
    item = {
      name: item.css('div.item-name').text,
      price: item.css('div.item-price').text,#.gsub(' ₫','').gsub('.','').to_i,
      image_url: item.css('img')[0].attributes["data-original"].value
    }
    items << item
    puts "Add #{item[:name]}"
    puts ""
  end
  byebug
end

scraper