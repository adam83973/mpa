class Transaction < ActiveRecord::Base
  belongs_to :student
  belongs_to :location
  belongs_to :user
  belongs_to :product

  TYPE = ["Redeem Credits", "Purchase", "Add Stock", "Reduce Stock"]
end
