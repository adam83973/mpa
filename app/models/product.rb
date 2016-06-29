class Product < ActiveRecord::Base

  validates_uniqueness_of :name, :scope => :location_id

  belongs_to :location
  has_many :transactions

  def price_in_dollars
    (price.to_d/100).to_s
  end
end
