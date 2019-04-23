require './FoodDB'
require './Log'

class DietManager
  def initialize()
    @dbFile = "FoodDB.txt"
    @logFile = "DietLog.txt"
    @database = FoodDB.new(@dbFile)
    @log = Log.new(@logFile)
    @dbChanged = false
    @logChanged = false

  end


  
  #Handles the 'quit' command which exits the DietManager
  def command_quit
	  exit(0) 
  end
  
  #Handles the 'save' command which saves the FoodDB and Log if necessary
  def command_save
 	#save fdb & log
	@database.save
	@log.save
  end

  #Handles the 'new food' command which adds a new BasicFood to the FoodDB
  def command_newFood(name, calories)
 	if @database.contains?(name)
		puts "Food already in database"
	else
		@database.add_basicFood(name, calories)
	end
  end

  #Handles the 'new recipe' command which adds a new Recipe to the FoodDB
  def command_newRecipe(name, ingredients)
	@database.add_recipe(name, ingredients)	
  end

  #Handles the 'print' command which prints a single item from the FoodDB
  def command_print(name)
	item = @database.get(name)
	if item == nil
		puts "#{name} not in database!"
	else
		puts item
	end
  end

  #Handles the 'print all' command which prints all items in the FoodDB
  def command_printAll
 	list = @database.find_matches("")
	list.each {|item|
		puts "#{item}"
	}

  end

  #Handles the 'find' command which prints information on all items in the FoodDB matching a certain prefix
  def command_find(prefix)
  	list = @database.find_matches(prefix)
	list.each {|match|
		puts "#{match}"
	}
  end

  #Handles both forms of the 'log' command which adds a unit of the named item to the log for a certain date
  def command_log(name, date = Date.today)
	@log.add_logItem(name, date) 
  end

  #Handles the 'delete' command which removes one unit of the named item from the log for a certain date
  def command_delete(name, date)
 	@log.remove_logItem(name,date)
  end

  #Handles both forms of the 'show' command which displays the log of items for a certain date
  def command_show(date = Date.today)
	
 	list = @log.get_entries(date)
	if list == nil
		puts "no entries for that date"
	else
		list.each {|entry|
			puts "#{entry.name}"
		}
	end
  end

  #Handles the 'show all' command which displays the entire log of items
  def command_showAll
	  list = @log.get_entries
	  map = Hash.new
	  list.each {|entry|
		  str = entry.date.to_s
		  if str[0] == "-"
			  str[0] = ""
		  end
		  (map[str] ||= []) << entry.name
	  }
	  iter = map.keys
	  iter.sort!
	  iter.each {|key|
		  puts key
		  map[key].each {|value|
			  puts "\t #{value}"
		  }
	  }
  end
  
end #end DietManager class


#MAIN

dietManager = DietManager.new

puts "Input a command > "

#Read commands from the user through the command prompt
$stdin.each{|line|
  
#Handle the input
	fields = line.split(" ")
	if fields[0] == "quit"	
		dietManager.command_quit
	elsif fields[0] == "save"
		dietManager.command_save
	elsif fields[0] == "new"
		if fields[1] == "food"
			info = fields[2].split(",")	#might want to ensure proper input
			dietManager.command_newFood(info[0], info[1])	
		elsif fields[1] == "recipe"
			#throw error if info0 in db or info1+ not in db
			info = fields[2..20]
			info = info.join(" ")
			info = info.split(",")
			dietManager.command_newRecipe(info[0], info[1..20])	
		end
	elsif fields[0] == "print"
		if fields[1] == "all"
			dietManager.command_printAll	
		else
			name = fields[1..20]
			dietManager.command_print(name.join(" "))
		end
	elsif fields[0] == "find"
		dietManager.command_find(fields[1])
	elsif fields[0] == "log"
		info = fields[1..10].join(" ")
		if (/,/ =~ info) != nil
			info = info.split(",")
			dietManager.command_log(info[0],Date.parse(info[1]))
		else
			dietManager.command_log(info)
		end
	elsif fields[0] == "show"
		if fields[1] == "all"
			dietManager.command_showAll
		elsif fields.length >= 2
			dietManager.command_show(Date.parse(fields[1]))
		else
			dietManager.command_show	
		end
	elsif fields[0] == "delete"
		if fields.length > 1
			info = fields[1..10].join(" ")
			info = info.split(",")
			dietManager.command_delete(info[0], Date.parse(info[1]))
		end
	else 
		puts "Unrecogized Command"
	end
	
	
  	
 } #closes each iterator

#end MAIN
