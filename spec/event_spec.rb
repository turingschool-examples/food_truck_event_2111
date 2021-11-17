require 'date'
require './lib/item'
require './lib/food_truck'
require './lib/event'

RSpec.describe Event do
  let(:event) {Event.new("South Pearl Street Farmers Market")}
  let(:food_truck1) {FoodTruck.new("Rocky Mountain Pies")}
  let(:item1) {Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})}
  let(:item2) {Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})}
  let(:item3) {Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})}
  let(:item4) {Item.new({name: "Banana Nice Cream", price: "$4.25"})}
  let(:item5) {Item.new({name: 'Onion Pie', price: '$25.00'})}
  let(:food_truck2) {FoodTruck.new("Ba-Nom-a-Nom")}
  let(:food_truck3) {FoodTruck.new("Palisade Peach Shack")}
  let(:stock_items) do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)
    food_truck3.stock(item3, 10)
  end
  let (:add_trucks) do
    event.add_food_truck(food_truck1)
    event.add_food_truck(food_truck2)
    event.add_food_truck(food_truck3)
  end

  it 'exists' do
    expect(event).to be_an_instance_of(Event)
  end

  it 'has attributes' do
    expect(event.name).to eq('South Pearl Street Farmers Market')
    expect(event.food_trucks).to eq([])

    allow(event).to receive(:date) {'24/02/2020'}
    expect(event.date).to eq('24/02/2020')
  end

  it 'can add food trucks' do
    expect(event.food_trucks).to eq([])

    add_trucks

    expect(event.food_trucks).to eq([food_truck1, food_truck2, food_truck3])
  end

  it 'can return the names of all the food trucks' do
    add_trucks

    expect(event.food_truck_names).to eq(["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
  end

  it 'can return the food trucks that sell an item' do
    stock_items
    add_trucks

    expect(event.food_trucks_that_sell(item1)).to eq([food_truck1, food_truck3])
    expect(event.food_trucks_that_sell(item4)).to eq([food_truck2])
  end

  it 'can check the total inventory' do
    stock_items
    add_trucks
    expected = {
      item1 => {
        quantity: 100,
        food_trucks: [food_truck1, food_truck3]
      },
      item2 => {
        quantity: 7,
        food_trucks: [food_truck1]
      },
      item4 => {
        quantity: 50,
        food_trucks: [food_truck2]
      },
      item3 => {
        quantity: 35,
        food_trucks: [food_truck2, food_truck3]
      },
    }

    expect(event.total_inventory).to eq(expected)
  end

  it 'can return a sorted list of all items in stock by strucks' do
    stock_items
    add_trucks
    expected = ["Apple Pie (Slice)", "Banana Nice Cream", "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"]

    expect(event.sorted_item_list).to eq(expected)
  end

  it 'can identify overstocked items' do
    stock_items
    add_trucks

    expect(event.overstocked_items).to eq([item1])
  end

  it 'can sell items' do
    food_truck1.stock(item1, 35)
    food_truck1.stock(item2, 7)
    food_truck2.stock(item4, 50)
    food_truck2.stock(item3, 25)
    food_truck3.stock(item1, 65)
    add_trucks

    expect(event.sell(item1, 200)).to eq(false)
    expect(event.sell(item5, 1)).to eq(false)
    expect(event.sell(item4, 5)).to eq(true)

    expect(food_truck2.check_stock(item4)).to eq(45)
    expect(event.sell(item4, 40)).to eq(true)

    expect(event.sell(item1, 40)).to eq(true)
    expect(food_truck1.check_stock(item1)).to eq(0)
    expect(food_truck3.check_stock(item1)).to eq(60)
  end
end
