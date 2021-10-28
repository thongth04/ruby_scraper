require 'nokogiri'
require 'httparty'
require 'byebug'

def scraper
  url = "https://vietnam.atalink.com/sub-cat/may-chu-thiet-bi-mang"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  items = Array.new
  raw_items = parsed_page.css('a>div.ant-card')

  page = 1
  per_page_items = raw_items.count #32
  total_items = parsed_page.css('div.sc-fzoNJl.sc-pscky.cSbqLu').text.split[0].to_i #499
  last_page = (total_items.to_f / per_page_items.to_f).ceil

  while page <= last_page
    pagination_url = "https://vietnam.atalink.com/sub-cat/may-chu-thiet-bi-mang?page=#{page}"
    puts pagination_url
    puts "Page: #{page}"
    puts ""
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
    pagination_raw_items = pagination_parsed_page.css('a>div.ant-card')
    pagination_raw_items.each do |item|
      item = {
        name: item.css('div.sc-fzoNJl.sc-pscky.sc-pIvzE').text,
        price: item.css('div.sc-fzoNJl.sc-pscky.TextWithLineNumber___StyledText-p1yx8y-0').text.gsub('₫ / Cái','').gsub('.','').to_i,
        image_url: item.css('img')[-1].attributes["src"].value
      }
      items << item
      puts "Add #{item[:name]}"
      puts ""
    end
    page += 1
  end
  byebug
end

scraper