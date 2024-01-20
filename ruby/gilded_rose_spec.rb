require 'rspec'
require 'simplecov'
SimpleCov.start

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  it "does not change the name" do
    items = [Item.new("foo", 0, 0)]
    GildedRose.new(items).update_quality()
    expect(items[0].name).to eq "foo"
  end

  context "Given a non-specific item" do
    let(:items) { [Item.new("Embossed Leather Boots", 10, 20)]}
    let(:gs) { GildedRose.new(items) }
    subject { items[0] }
    it "should lower the sell in by 1" do
      3.times { gs.update_quality }
      expect(subject.quality).to eq 17
    end
    it "should lower the quality by 1" do
      3.times { gs.update_quality }
      expect(subject.sell_in).to eq 7
    end
    context "Once sell in is 0" do
      it "reduces quality twice as fast" do
        10.times { gs.update_quality }
        gs.update_quality
        expect(subject.quality).to eq 8
      end
    end

    it "Item quality can never be negative" do
      20.times { gs.update_quality }
      expect(subject.quality).to eq 0
    end
  end

  context "Aged Brie" do
    let(:items) { [Item.new("Aged Brie", 12, 1)] }
    let(:gs) { GildedRose.new(items) }
    subject { items[0].quality }
    it "increase in quality the older it gets" do
      5.times { gs.update_quality }
      expect(subject).to eq 6
    end
    it "cannot go higher than 50 quality" do
      60.times { gs.update_quality }
      expect(subject).to eq 50
    end
  end

  context "Backstage passes" do
    let(:sell_in) { 12 }
    let(:quality) { 1 }
    let(:items) { [Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality)] }
    let(:gs) { GildedRose.new(items) }
    subject { items[0].quality }

    context "quality increases" do
      it "by 1 when there are more than 10 day left" do
        gs.update_quality()
        expect(subject).to eq 2
      end
      it "by 2 when there are 10 days or less" do
        3.times { gs.update_quality }
        expect(subject).to eq 5
      end
      it "by 3 when there are 5 days or less" do
        # 2 # 3
        # 5 # 7 # 9 # 11 # 13
        # 16
        8.times { gs.update_quality }
        expect(subject).to eq 16
      end
    end
    it "quality is 0 when sell in is 0" do
      13.times { gs.update_quality }
      expect(subject).to eq 0
    end

    context "given a longer sell in" do
      let(:sell_in) { 100 }
      it "should never exceed 50 quality" do
        50.times { gs.update_quality }
        expect(subject).to eq 50
      end
    end
  end

  context "Sulfuras" do
    let(:items) { [Item.new("Sulfuras, Hand of Ragnaros", 12, 17)] }
    let(:gs) { GildedRose.new(items) }
    subject { items[0] }
    it "should maintain quality" do
      8.times { gs.update_quality }
      expect(subject.quality).to eq 17
    end
    it "should maintain sell in doesn't decrease" do
      8.times { gs.update_quality }
      expect(subject.sell_in).to eq 12
    end
  end
end

describe Item do
  it "returns the name, sell in, and quality" do
    item = Item.new("Leather Jacket", 10, 5)
    expect(item.to_s).to eq "Leather Jacket, 10, 5"
  end
end
