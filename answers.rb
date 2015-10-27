class Stocks

	def self.get_companies
		@@companies = {apple: { :path => "http://finance.yahoo.com/q?s=AAPL", :price => "//span[@id='yfs_l84_aapl']", :closing => "//td[@class='yfnc_tabledata1']", :name => "Apple"},
								google: { :path => "http://finance.yahoo.com/q?s=GOOG", :price => "//span[@id='yfs_l84_goog']", :closing => "//td[@class='yfnc_tabledata1']", :name => "Google"}
								}
	end

	require "httparty"
	require "nokogiri"
	require "bigdecimal"
	require "money"

	Money.use_i18n = false
	
	def self.get_price dom, path
		apple_stock = dom.xpath(path)
		price = BigDecimal.new(apple_stock.first.content)
		price = Money.us_dollar(price*100).format(with_currency: true)
	end

	def self.get_closing_price dom, path
		apple_stock_previous_closing = dom.xpath(path)
		closing_price = BigDecimal.new(apple_stock_previous_closing.first.content)
		closing_price = Money.us_dollar(closing_price*100).format(with_currency: true)
	end

	def self.get_response url
		request_url = url
		response = HTTParty.get(request_url)
	end

	def self.output_stocks company, current_price, previous_price
		puts "Current price for the #{company} stocks are #{current_price}"
		puts "Previous closing price for #{company} stocks are #{previous_price}"
	end

	def self.stock_price company
		response = get_response self.get_companies[company][:path]
		dom = Nokogiri::HTML(response.body)
		output_stocks(self.get_companies[company][:name], get_price(dom, self.get_companies[company][:price]), get_closing_price(dom, self.get_companies[company][:closing]))
	end

end

Stocks.stock_price :google
Stocks.stock_price :apple


--------------------------------------------------------------------------------------------

require 'sinatra'
require 'httparty'
require 'nokogiri'
require 'bigdecimal'
require 'money'
require_relative 'stocks'

get "/" do

end

get "/this" do
	"Hello, World!"
end

get "/sinatra" do
	"Hello, Sinatra"
end