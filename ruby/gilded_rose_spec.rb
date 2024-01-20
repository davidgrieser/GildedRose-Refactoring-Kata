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
end

describe Item do
  it "returns the name, sell in, and quality" do
    item = Item.new("Leather Jacket", 10, 5)
    expect(item.to_s).to eq "Leather Jacket, 10, 5"
  end
end
