require 'jsonpath'
require 'httparty'

#Get products data
response = HTTParty.get('http://shopicruit.myshopify.com/products.json')

#Store and parse response
raw_api_data = JSON.parse(response.body)

#Find and save the my obsessions
wallets_hash = raw_api_data['products'].select {|h1| h1['product_type']=='Wallet'}
lamps_hash = raw_api_data['products'].select {|h1| h1['product_type']=='Lamp'}

#Setup JsonPath to select the prices stored for the different lamp and wallet varations 
path = JsonPath.new('$..price')

wallet_prices =  path.on(wallets_hash).map(&:to_f)
lamps_prices =  path.on(lamps_hash).map(&:to_f)


#Calculate the sum for all the items
wallets_sum = wallet_prices.inject{|sum,x| sum + x }
lamps_sum = lamps_prices.inject{|sum,x| sum + x }

total_sum =  (wallets_sum + lamps_sum).round(2)

puts "The total to buy all your obsessions is $#{total_sum}"