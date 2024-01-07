puts 'Hello, World!'


x = 0
while x < 5
  puts "x is #{x}"
  x += 1
end

puts "For loop"

for i in 0..4
  puts "i is #{i}"
end


5.times do |i|
  puts "i is #{i}"
end


[1, 2, 3, 4, 5].each do |i|
  puts "i is #{i}"
end


def greet(name)
  puts "Hello, #{name}!"
end

greet("Ayush")