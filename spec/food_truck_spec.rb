require_relative './spec_helper'

RSpec.describe FoodTruck do
  let (:food_truck) {FoodTruck.new("Rocky Mountain Pies")}
  let (:item1) {Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})}
  let (:item2) {Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})}
  let (:item3) {Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})}
  let (:item4) {Item.new({name: "Banana Nice Cream", price: "$4.25"})}
  let (:food_truck1) {FoodTruck.new("Rocky Mountain Pies")}
  let (:food_truck2) {FoodTruck.new("Ba-Nom-a-Nom")}
  let (:food_truck3) {FoodTruck.new("Palisade Peach Shack")}

  it 'exists' do
    expect(food_truck). to be_instance_of FoodTruck
  end

  it 'initializes with a name' do
    expect(food_truck.name).to eq("Rocky Mountain Pies")
  end

  it 'begins with no inventory' do
    expect(food_truck.inventory).to eq({})
  end

  it 'can stock items in inventory and check the stock' do
    expect(food_truck.inventory).to eq({})
    expect(food_truck.check_stock(item1)).to eq(0)

    food_truck.stock(item1, 30)

    expect(food_truck.inventory).to eq({item1 => 30})
    expect(food_truck.check_stock(item1)).to eq(30)
  end

  it 'can stock muliple items to inventory and check the stock' do
    expect(food_truck.inventory).to eq({})

    food_truck.stock(item1, 30)
    expect(food_truck.inventory).to eq({item1 => 30})

    food_truck.stock(item1, 25)
    expect(food_truck.check_stock(item1)).to eq(55)

    food_truck.stock(item2, 12)
    expect(food_truck.inventory).to eq({item1 => 55, item2 => 12})
  end

  it 'can calculate the potential revenue as sum of all items price * qty' do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)

    expect(food_truck1.potential_revenue).to eq(148.75)
    expect(food_truck2.potential_revenue).to eq(345.00)
    expect(food_truck3.potential_revenue).to eq(243.75)
  end
end
