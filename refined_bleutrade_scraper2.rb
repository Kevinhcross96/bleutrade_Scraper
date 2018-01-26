require 'JSON'
require 'open-uri'
require 'certified'
require 'csv'
require 'watir'
require 'watir-scroll'

# INSTALL CHROMEDRIVER HERE
# C:\RailsInstaller\Ruby2.3.0\bin

file_title = 1
file_created = false
user_done = "Quack"

titles = ["T.I.D.","I.D.", "Date", "Source", "Action", "Symbol", "Volume", "Currency", "Price", "Fee", "Value"]

until file_created == true
	if File.exists?("bleutrade_data#{file_title}.csv")
		file_title += 1
	end

	CSV.open("bleutrade_data#{file_title}.csv", 'w+') do |csv|
		csv.puts titles
		file_created = true
	end
end

	Watir.default_timeout = 300

	browser = Watir::Browser.new

	browser.goto('https://bleutrade.com/login')

	puts "Please log in to your account and type anything to continue."

	next_step = gets 

	# browser.link(:href => "/member/my_transactions").click

	done_ids = []

until user_done == "Done"

	# browser.select_list(:name => "tabela_my_transactions_length").select("100")

	puts "-------------------------------"

	limit = browser.div(:id => "tabela_my_transactions_info").text

	limit = limit.split(" ")

	limit = limit[3].to_i

	while limit > 100
		limit = limit - 100
	end



	counter = 0

	data_dir = "bleutrade_scraper/coin_data"

	until counter == limit

		transaction_id = "zil"
		date_time = "zil"
		value = "zil"
		details = "zil"
		inner_id = "zil"
		inner_time = "zil"
		buy_sell = "zil"
		total = "zil"
		price = "zil"
		btc = "zil"
		vol1 = "zil"
		vol2 = "zil"
		fee = "nil"
		symbol1 = "zil"
		symbol2 = "zil"
		symbol3 = "zil"
		volume = "nil"

		greater_dates = []
		data = []
		limit2 = 0
		counter2 = 0


		row = browser.table(:id => "tabela_my_transactions").tbody.tr(:role => "row", :index => counter)

		if row.link.present?

		transaction_id = row.td(:class => "text-center").text
		date_time = row.td(:class => "text-center", :index => 1).text
		value = row.td(:class => "text-right").text
		details = row.td(:class => "text-left").text
		details = details.split("fee")
		# date_time_count = browser.table(:id => "tabela_my_transactions").tbody.text
		# date_time_count = date_time_count.split(" ")
		# date_time_count2 = []
		# date_time_count2.push(date_time_count[1])
		# date_time_count2.push(date_time_count[2])
		# date_time_count = date_time_count2.join(" ")

		# date_time_count3 = browser.table(:id => "tabela_my_transactions").count

		# if row.link.present? && (done_ids.include?(row.link.text) != true)
		# if row.link.present?

			done_ids.push(row.link.text)

			browser.scroll.to :bottom

			row.link.click

			sleep 3
			
			# limit2 = 0
			# counter2 = 0
			# dup_counter = 0

			# limit2 = browser.table(:class => "table-striped", index: 1).tbody(:id => "order_history_modal").tds(:class => "text-center").count

			# until counter2 == limit2

				data = []

				# inner_row = browser.table(:class => "table-striped", index: 1).tbody(:id => "order_history_modal").tr(:index => counter2)
				# inner_time = inner_row.td.text
				inner_id = browser.table(:class => "table-striped").td(:class => "text-center").text
				# vol1 = inner_row.td(index: 2).text
				# vol2 = inner_row.td(index: 3).text
				# inner_time = browser.table(:class => "table-striped").td(:class => "text-center", index: 1).text
				buy_sell = browser.table(:class => "table-striped").td(:class => "text-center", index: 2).text
				# total = browser.table(:class => "table-striped").td(:class => "text-right").text
				price = browser.table(:class => "table-striped").td(:class => "text-right", index: 1).text
				# btc = browser.table(:class => "table-striped").td(:class => "text-right", index: 2).text



				symbol1 = browser.table(:class => "table-striped", index: 1).div(:id => "modal_body_orderid_dividend3").text
				symbol2 = browser.table(:class => "table-striped", index: 1).div(:id => "modal_body_orderid_divisor2").text

				# symbol3 = symbol1 + "/" + symbol2

				if details.length > 1
					fee = details.last.to_f
				end

				# if date_time == inner_time

					data.push(transaction_id)

					if inner_id != "zil"
						data.push(inner_id)
					end
			
					data.push(date_time)
			
					data.push("Bleutrade")
			
					if buy_sell != "zil"
						data.push(buy_sell)
					end

					data.push(symbol1)
					# if symbol1 != "zil"
					# 	data.push(symbol1)
					# end

					# if symbol2 != "zil"
					# 	data.push(symbol2)
					# end

					if buy_sell == "SELL"
						volume = (value.to_f.abs + fee.to_f.abs) / price.to_f.abs
					elsif buy_sell == "BUY"
						volume = (value.to_f.abs - fee.to_f.abs) / price.to_f.abs
					end
						

					data.push(volume)

					data.push(symbol2)

					if price != "zil"
						data.push(price.to_f.abs)
					end

					# if vol1 != "zil"
					# 	data.push(vol1)
					# end

					# if vol2 != "zil"
					# 	data.push(vol2)
					# end

						# data.push(fee)

						# data.push(value)

						data.push(fee.to_f.abs)
						data.push(value.to_f.abs)

						CSV.open("bleutrade_data#{file_title}.csv", 'a') do |csv|
							# dup_counter += 1
							# if dup_counter >= 2
							# 	data.push("DUP")
							# end
							csv.puts data
							puts "Data saved"
						end
				# end
				# counter2 += 1
			# end

			browser.button(:class => "close").click

			sleep 1

		end

		counter += 1

	end

	puts "Page has been scraped."
	puts "Please move to the next page and type anything into the console to scrape that page."
	puts "You can also type 'Done' to exit the program."

	user_done = gets.chomp

end

puts "Scrape complete. Please see bleutrade_data#{file_title}.csv for your data."