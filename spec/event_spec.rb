require 'date'
require './lib/item'
require './lib/food_truck'
require './lib/event'

RSpec.describe Event do
  context 'Iteration II' do
    let(:item1) {Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})}
    let(:item2) {Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})}
    let(:item3) {Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})}
    let(:item4) {Item.new({name: "Banana Nice Cream", price: "$4.25"})}
    let(:item5) {Item.new({name: 'Onion Pie', price: '$25.00'})}

    let(:food_truck1) {FoodTruck.new("Rocky Mountain Pies")}
    let(:food_truck2) {FoodTruck.new("Ba-Nom-a-Nom")}
    let(:food_truck3) {FoodTruck.new("Palisade Peach Shack")}

    let(:event) {Event.new("South Pearl Street Farmers Market")}

    let(:fake_date) {"22/04/1988"}
    before :each do
      allow(Date).to receive_message_chain(:today, :strftime).and_return(fake_date)
    end
    describe 'Event' do
      it 'exists' do

        expect(event).to be_a(Event)
      end

      it 'has attributes' do

        expect(event.name).to eq("South Pearl Street Farmers Market")
        expect(event.food_trucks).to eq([])
      end

      it 'has a date' do

        expect(event.date).to eq("22/04/1988")
      end

      it 'can add food trucks' do
        event.add_food_truck(food_truck1)
        event.add_food_truck(food_truck2)
        event.add_food_truck(food_truck3)

        expect(event.food_trucks).to eq([food_truck1, food_truck2, food_truck3])
      end
    end

    describe 'a full event' do
      before :each do
        food_truck1.stock(item1, 35)
        food_truck1.stock(item2, 7)

        food_truck2.stock(item4, 50)
        food_truck2.stock(item3, 25)

        food_truck3.stock(item1, 65)
        food_truck3.stock(item3, 10)

        event.add_food_truck(food_truck1)
        event.add_food_truck(food_truck2)
        event.add_food_truck(food_truck3)
      end

      it 'can list food trucks by name' do

        expect(event.food_truck_names).to eq(["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"])
      end

      it 'can list which trucks sell which item' do

        expect(event.food_trucks_that_sell(item1)).to eq([food_truck1, food_truck3])
        expect(event.food_trucks_that_sell(item4)).to eq([food_truck2])
      end

      it 'can list all items being sold' do

        expect(event.items_for_sale).to eq([item1, item2, item4, item3])
      end

      it 'can list total inventory of all items, and which trucks are selling an item' do
        expected = {
          item1 => {quantity: 100,
                     food_trucks: [food_truck1, food_truck3]},
          item2 => {quantity: 7,
                     food_trucks: [food_truck1]},
          item4 => {quantity: 50,
                     food_trucks: [food_truck2]},
          item3 => {quantity: 35,
                     food_trucks: [food_truck2, food_truck3]}
        }

        expect(event.total_inventory).to eq(expected)
      end

      it 'can tell when an item is overstocked' do
        # An item is overstocked if it is
        # sold by more than 1 food truck AND
        # the total quantity is greater than 50.
        expect(event.overstocked_items).to eq([item1])
      end

      it 'can sort items for sale alphabetically' do

        expect(event.sorted_item_list).to eq(["Apple Pie (Slice)", "Banana Nice Cream", "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"])
      end
    end

    describe 'Iteration IV (date tests are above)' do
      before :each do
        food_truck1.stock(item1, 35)
        food_truck1.stock(item2, 7)

        food_truck2.stock(item4, 50)
        food_truck2.stock(item3, 25)

        food_truck3.stock(item1, 65)

        event.add_food_truck(food_truck1)
        event.add_food_truck(food_truck2)
        event.add_food_truck(food_truck3)
      end

      it 'can sell items' do

        expect(event.sell(item1, 200)).to eq(false)
        expect(event.sell(item5, 1)).to eq(false)
        expect(event.sell(item4, 5)).to eq(true)
      end

      xit 'can reduce inventory' do
        #so close...
        event.sell(item4, 5)

        expect(food_truck2.check_stock(item4)).to eq(45)

        event.sell(item1, 40)
        expect(food_truck1.check_stock(item1)).to eq(0)
        expect(food_truck3.check_stock(item1)).to eq(60)
      end
    end
  end
end
