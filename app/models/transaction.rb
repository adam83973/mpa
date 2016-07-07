class Transaction < ActiveRecord::Base
  belongs_to :student
  belongs_to :location
  belongs_to :user
  belongs_to :product

  before_save :compute_credits
  after_save :update_inventory

  validates_presence_of :location_id, :product_id

  PROCESSES = ["Redeem Credits", "Purchase", "Add Inventory", "Reduce Intventory"]

  def compute_credits
    if process == 0
      self.credits_redeemed = product.credits
    end
  end

  def update_inventory
    case process
    when 0 #when redeeming credits adjust stock of product by 1
      product.decrease_stock_by_one # adjust quantity for product redeemed with credits
    when 2
      product.add_stock(quantity)
    when 3
      product.remove_stock(quantity)
    end
  end
end
