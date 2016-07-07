class Product < ActiveRecord::Base

  validates_uniqueness_of :name, :scope => :location_id

  belongs_to :location
  has_many :transactions

  def add_stock(quantity)
    increment!(:quantity, quantity.to_i)
  end

  def decrease_stock_by_one
    decrement!(:quantity)
  end

  def price_in_dollars
    (price.to_d/100).to_s
  end

  def remove_stock(quantity)
    decrement!(:quantity, quantity.to_i)
  end
end
