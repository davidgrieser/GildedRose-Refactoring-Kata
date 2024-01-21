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
    end
  end

  class Sulfuras < BaseItem
    def update
    end
  end

  SPECIAL_ITEMS = [
    "Aged Brie",
    "Backstage passes to a TAFKAL80ETC concert",
    "Sulfuras, Hand of Ragnaros"
  ]

  def initialize(items)
    @items = items
    @parsed_items = items.map do |item|
      if item.name == SPECIAL_ITEMS[0]
        puts "Creating Aged Brie"
        AgedBrie.new(item)
      elsif item.name == SPECIAL_ITEMS[1]
        BackstagePass.new(item)
      elsif item.name == SPECIAL_ITEMS[2]
        Sulfuras.new(item)
      elsif SPECIAL_ITEMS.include?(item.name)
        item
      else
        BaseItem.new(item)
      end
    end
  end

  def update_quality()
    @parsed_items.each do |item|
      if item.class == BaseItem || item.class == AgedBrie || item.class == BackstagePass || item.class == Sulfuras
        item.update
        next
      end
      if item.name != "Aged Brie" and item.name != "Backstage passes to a TAFKAL80ETC concert"
        if item.quality > 0
          if item.name != "Sulfuras, Hand of Ragnaros"
            item.quality = item.quality - 1
          end
        end
      else
        if item.quality < 50
          item.quality = item.quality + 1
          if item.name == "Backstage passes to a TAFKAL80ETC concert"
            if item.sell_in < 11
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
            if item.sell_in < 6
              if item.quality < 50
                item.quality = item.quality + 1
              end
            end
          end
        end
      end
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.sell_in = item.sell_in - 1
      end
      if item.sell_in < 0
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            if item.quality > 0
              if item.name != "Sulfuras, Hand of Ragnaros"
                item.quality = item.quality - 1
              end
            end
          else
            item.quality = item.quality - item.quality
          end
        else
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
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
