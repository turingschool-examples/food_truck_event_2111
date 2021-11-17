require './lib/item'

class FoodTruck
  attr_reader :name, :inventory

  def initialize(name)
    @name = name
    @inventory = {}
  end

  def check_stock(item)
    if @inventory.include?(item)
      return @inventory[item]
    else
      return 0
    end 
  end
end
