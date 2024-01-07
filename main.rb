puts 'Hello, World!'

require 'net/http'

url = URI.parse('https://www.capgemini.com/')
begin
  response = Net::HTTP.get_response(url)
  puts 'Website is up!' if response.code == '200'
rescue StandardError
  puts 'Website might be down!'
end

require 'fileutils'

###############################################
# Directory where the files are located
directory_path = 'server.log'

# Log file to write the names of files with errors
log_file = 'error_log.txt'

# Open the log file to append
File.open(log_file, 'a') do |log|
  # Scan through each file in the directory
  Dir.glob("#{directory_path}/*.txt").each do |file_name|
    file_has_error = false
    File.foreach(file_name).with_index do |line, line_num|
      # Check if the line contains the word 'ERROR'
      if line.include? 'ERROR'
        # Write to log file (only once per file)
        unless file_has_error
          log.puts "Errors found in file: #{file_name}"
          file_has_error = true
        end
        # Log the specific error line
        log.puts "  Line #{line_num}: #{line.strip}"
      end
    end
  end
end

puts "Error logging complete. Check '#{log_file}' for details."

###########################################
error_count = 0
File.foreach('server.log') do |line|
  error_count += 1 if line.include?('ERROR')
end

puts 'Alert! High number of errors.' if error_count > 2

###############################

uptime = `uptime` # Using system call to get uptime
puts "Server Uptime: #{uptime}"

###############################################
# gem install sys-filesystem
# gem list sys-filesystem

require 'sys/filesystem'

def check_disk_space(path, threshold_percent)
  stat = Sys::Filesystem.stat(path)
  percent_used = (stat.bytes_used.to_f * 100 / stat.bytes_total.to_f).round(2)
  if percent_used > threshold_percent
    puts "Alert: Disk usage at #{percent_used}% on #{path}"
  else
    puts "Disk usage is at a healthy #{percent_used}% on #{path}"
  end
end

check_disk_space('/', 80) # Set threshold to 80%

# ruby main.rb
require 'rss'
require 'open-uri'

url = 'http://www.ruby-lang.org/en/feeds/news.rss'
URI.open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  puts "Title: #{feed.channel.title}"
  feed.items.each do |item|
    puts "Item: #{item.title}"
    puts "Link: #{item.link}"
    puts
  end
end

################
# gem install rubyzip
require 'zip'

def backup_directory(directory, output_file)
  # Get the full path of the directory to be backed up
  directory_path = File.join(File.dirname(__FILE__), directory)

  # Create a zip file
  Zip::File.open(output_file, Zip::File::CREATE) do |zipfile|
    # Recursively add files to the zip file
    Dir[File.join(directory_path, '**', '**')].each do |file|
      zipfile.add(file.sub(directory_path + '/', ''), file)
    end
  end
end


backup_directory('backup', 'backup.zip')
puts 'Directory has been backed up!'


#############

def service_running?(service_name)
  system("systemctl is-active --quiet #{service_name}")
end

def check_services_health
  services = ["nginx", "mysql", "redis"]
  services.each do |service|
    if service_running?(service)
      puts "#{service} is running."
    else
      puts "Alert: #{service} is not running!"
      # Here you might restart the service or send an alert
    end
  end
end

check_services_health

