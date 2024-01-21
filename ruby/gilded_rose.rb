class GildedRose
  class BaseItem
    attr_reader :item

    def initialize(item)
      @item = item
      @degrade_value = 1
    end

    def update
      @item.sell_in -= 1
      @item.quality -= @degrade_value
      @item.quality = 0 if @item.quality < 0
      @item.quality = 50 if @item.quality > 50
      update_degrade_value
    end

    def update_degrade_value
      if @item.sell_in == 0
        @degrade_value *= 2
      end
    end
  end

  class AgedBrie < BaseItem
    def initialize(item)
      super(item)
      @degrade_value = -1
    end
  end

  class BackstagePass < BaseItem
    def initialize(item)
      super(item)
      update_degrade_value
    end

    def update_degrade_value
      @degrade_value = -1 if @item.sell_in > 10
      @degrade_value = -2 if @item.sell_in <= 10
      @degrade_value = -3 if @item.sell_in <= 5
      @degrade_value = @item.quality if @item.sell_in == 0
      @degrade_value = 0 if @item.sell_in < 0
    end
  end

  class Sulfuras < BaseItem
    def update
    end
  end

  class ConjuredItem < BaseItem
    def initialize(item)
      super(item)
      @degrade_value *= 2
    end
  end

  SPECIAL_ITEMS = [
    "Aged Brie",
    "Backstage passes to a TAFKAL80ETC concert",
    "Sulfuras, Hand of Ragnaros",
    "Conjured Mana Cake"
  ]

  def initialize(items)
    @parsed_items = items.map do |item|
      if item.name == SPECIAL_ITEMS[0]
        AgedBrie.new(item)
      elsif item.name == SPECIAL_ITEMS[1]
        BackstagePass.new(item)
      elsif item.name == SPECIAL_ITEMS[2]
        Sulfuras.new(item)
      elsif item.name == SPECIAL_ITEMS[3]
        ConjuredItem.new(item)
      else
        BaseItem.new(item)
      end
    end
  end

  def update_quality()
    @parsed_items.each do |item|
      item.update
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
