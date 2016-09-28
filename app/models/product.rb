class Product < ActiveRecord::Base

  validates_uniqueness_of :name, :scope => :location_id

  belongs_to  :location
  has_many    :transactions
  has_many    :occupation_levels

  def name_location
    if location
      name + " (#{location.name})"
    else
      name + " (No Location Specified)"
    end
  end

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
