require './lib/event'

RSpec.describe Event do
  before(:each) do
    @event = Event.new("South Pearl Street Farmers Market")

    @food_truck1 = FoodTruck.new("Rocky Mountain Pies")
    @food_truck2 = FoodTruck.new("Ba-Nom-a-Nom")
    @food_truck3 = FoodTruck.new("Palisade Peach Shack")

    @item1 = Item.new({name: 'Peach Pie (Slice)', price: "$3.75"})
    @item2 = Item.new({name: 'Apple Pie (Slice)', price: '$2.50'})
    @item3 = Item.new({name: "Peach-Raspberry Nice Cream", price: "$5.30"})
    @item4 = Item.new({name: "Banana Nice Cream", price: "$4.25"})

    @food_truck1.stock(@item1, 35)
    @food_truck1.stock(@item2, 7)

    @food_truck2.stock(@item4, 50)
    @food_truck2.stock(@item3, 25)

    @food_truck3.stock(@item1, 65)
    @food_truck3.stock(@item3, 10)
  end

  it 'is initialized with a name and an empty collection of food trucks' do
    expect(@event).to be_an Event
    expect(@event.name).to be_a String
    expect(@event.name).to eq "South Pearl Street Farmers Market"
    expect(@event.food_trucks).to be_an Array
    expect(@event.food_trucks).to be_empty
  end

  describe '#add_food_truck' do
    before :each do
      @event.add_food_truck(@food_truck1)
      @event.add_food_truck(@food_truck2)
      @event.add_food_truck(@food_truck3)
    end

    it 'adds a food truck to the event' do
      expected = [@food_truck1, @food_truck2, @food_truck3]
      expect(@event.food_trucks).to eq expected
    end

    describe 'food_truck_names' do
      it 'returns a collection of the names of the food trucks' do
        expect(@event.food_truck_names).to eq ["Rocky Mountain Pies", "Ba-Nom-a-Nom", "Palisade Peach Shack"]
      end
    end

    describe 'food_trucks_that_sell' do
      it 'takes an item as an arg and returns a collection of all the trucks which sell that item' do
        expect(@event.food_trucks_that_sell(@item1)).to eq [@food_truck1, @food_truck3]
        expect(@event.food_trucks_that_sell(@item4)).to eq [@food_truck2]
      end
    end

    describe 'items' do
      it 'returns a collection of all the items sold at the event' do
        expect(@event.items).to eq [@item1, @item2, @item4, @item3]
      end
    end

    describe 'total_inventory' do
      it 'returns a hash of every trucks inventory' do
 #        expected ={{#<Item:0x00000001261040d8 @name="Peach Pie (Slice)", @price="$3.75">=>35, #<Item:0x0000000126104650 @name="Apple Pie (Slice)", @price="$2.50">=>7}=>
 #  {:food_trucks=>[], :quantity=>3},
 # {#<Item:0x00000001260ffda8 @name="Banana Nice Cream", @price="$4.25">=>50,
 #  #<Item:0x00000001260ffe70 @name="Peach-Raspberry Nice Cream", @price="$5.30">=>25}=>{:food_trucks=>[], :quantity=>3},
 # {#<Item:0x00000001261040d8 @name="Peach Pie (Slice)", @price="$3.75">=>75}=>{:food_trucks=>[], :quantity=>3}}
        expect(@event.total_inventory).to be_a Hash
        expect(@event.total_inventory.keys).to eq [@item1, @item2, @item4, @item3]
        @event.total_inventory.values.each do |value|
          expect(value).to be_a Hash
        end
      end
    end

    describe '#overstocked_items' do
      it 'returns a collection of all overstocked items' do
        expect(@event.overstocked_items).to eq [@item1]
      end
    end

    describe '#sorted_item_list' do
      it 'returns the names of the items sorted by alphabetical order(?)' do
        expect(@event.sorted_items_list).to eq ["Apple Pie (Slice)", "Banana Nice Cream", "Peach Pie (Slice)", "Peach-Raspberry Nice Cream"]
      end
    end
  end
end
