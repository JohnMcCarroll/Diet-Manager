require 'date'

class LogItem
  attr_accessor :name, :date

  #itemName is the name of the BasicFood and date is the date (civil format : xx/xx/xxxx) for which the food was added
  def initialize(itemName, date)
 
	#FILL IN
	@name = itemName
	@date = date
  end
  
  #Returns a string representation of this LogItem formatted for printing
  def to_s

	#FILL IN
	string = "#{@date},#{@name}"
	string
  end
end
