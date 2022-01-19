require 'pry'
require './lib/item'

class FoodTruck
  attr_reader :name, :inventory, :potential_revenue

  def initialize(name)
    @name = name
    @inventory = Hash.new(0)
  end

  def check_stock(item)
    @inventory[item]
  end

  def stock(item, quantity)
    @inventory[item] += quantity
  end
end
