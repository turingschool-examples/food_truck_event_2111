class FoodTruck
  attr_reader :name,
              :inventory

  def initialize(name)
    @name      = name
    @inventory = Hash.new { |hash, key| hash[key] = 0 }
  end

  def stock(item, qty)
    @inventory[item] += qty
  end

  def check_stock(item)
    @inventory[item]
  end

end
