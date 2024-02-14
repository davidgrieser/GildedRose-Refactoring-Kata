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
    DEGRADE_MAP = {
      ..-1 => 0,
      1..5 => -3,
      6..10 => -2,
      10.. => -1,
    }
    def initialize(item)
      super(item)
      update_degrade_value
    end

    def update_degrade_value
      if @item.sell_in == 0
        @degrade_value = @item.quality
      else
        @degrade_value = DEGRADE_MAP.select { |k| k === @item.sell_in }.values.first
      end
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

  SPECIAL_ITEMS_MAP = {
    "Aged Brie" => AgedBrie,
    "Backstage passes to a TAFKAL80ETC concert" => BackstagePass,
    "Sulfuras, Hand of Ragnaros" => Sulfuras,
    "Conjured Mana Cake" => ConjuredItem
  }

  def initialize(items)
    @parsed_items = items.map do |item|
      if SPECIAL_ITEMS_MAP.keys.include?(item.name)
        SPECIAL_ITEMS_MAP[item.name].new(item)
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
