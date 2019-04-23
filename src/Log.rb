require './LogItem'

class Log
  attr_accessor :size
  
  #filename is the name of the Log file to be used
  def initialize(filename)
    @log = Hash.new
    @size = 0
    
    
	@logFile = File.new(filename) #Open the log file
    
    #Read in the Log file
    @logFile.each{|line|
      values = line.split(',') #Split the line at the commas
      dateParts = values[0].split('-') #Split the date field up at the slashes
     
	#test
      #puts "#{dateParts[0]}"
      if dateParts[0] == ""
	      dateParts = dateParts[1..3]
      end

      date = Date.parse("#{dateParts[2]}-#{dateParts[0]}-#{dateParts[1]}") #Parse the date string into a valid Date object
      
      add_logItem(values[1].chomp!, date)
    }
  end
  
  #Adds a LogItem to the Log for the given date and name, returns true if successful, false otherwise
  def add_logItem(name, date)

  
    #If there are already entries for logItem's date, add the LogItem
    #Otherwise add a new entry for logItem's date and add the LogItem to its list
	  item = LogItem.new(name, date)
	  if @log.has_key?(date)
		  @log[date].insert(-1,item)
	  else
		  @log[date] = Array.new
		  @log[date].insert(0,item)
	  end
	  @size += 1
  end
  
  #Removes a LogItem from the Log for the given date and name
  def remove_logItem(name, date)
	  if contains?(name, date)
		 @size -= 1 
		 @log[date].each {|item|
			 if item.name == name && item.date == date
				 return @log[date].delete(item)
			 end}
	  end
  end
  
  #Returns true if there is an entry for this date with the given name, false otherwise
  def contains?(name, date)
   	if not @log.has_key?(date)
		return false
	else
		list = @log[date]
		list.each {|item|  
			if item.name == name && item.date == date
				return true
			end }
	end
	false

  end
  
  #Returns an Array of LogItems for the given date, nil if there are no entries for the date
  #If no date is passed, returns all entries in the Log
  def get_entries(date = nil)
	  if date == nil
		entries = Array.new
		@log.each_key {|key| entries.concat(@log[key])}
		return entries
	  elsif !@log.has_key?(date) 
		  puts "hey"
		  return nil
	  elsif @log[date].empty?
		  puts "listen"
		return nil
	  else
		  return @log[date]
	  end

  end
  
  #Saves the log to @logFile
  def save
    #Write all save data to the log file
    File.open(@logFile, "w+"){|fOut|
      get_entries.flatten.each{|logItem|
        fOut.write(logItem.to_s)
        fOut.write("\n")
      }
    }
  end
end
