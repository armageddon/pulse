require 'rubygems'
require 'postgres'

conn = PGconn.new(:host => "localhost", :user => "dusty", :dbname => "pulse_development")
# res = conn.exec('select id, address from places limit 5')
res = conn.exec('select id, address from places')
res.each do |r|
  puts "#{r[0]} --- #{r[1]}"
end