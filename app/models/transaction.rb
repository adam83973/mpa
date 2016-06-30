class Transaction < ActiveRecord::Base
  belongs_to :student
  belongs_to :location
  belongs_to :user
  belongs_to :product

  before_save :compute_credits

  PROCESSES = ["Redeem Credits", "Purchase", "Add Stock", "Reduce Stock"]

  def compute_credits
    if process == 0
      self.credits_redeemed = product.credits
    end
  end
end
