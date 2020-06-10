require "csv"
media_file = Rails.root.join("db", "products.csv")

CSV.foreach(media_file, headers: true, header_converters: :symbol, converters: :all) do |row|
  data = Hash[row.headers.zip(row.fields)]
  puts data
  Product.create!(data)
end

