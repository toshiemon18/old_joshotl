Thread.fork do
	while(true)
      puts 'foked thread'
     end
end
while(true)
  puts 'main thread'
 end