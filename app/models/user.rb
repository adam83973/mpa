class User < ActiveRecord::Base
  attr_accessible :active, :address, :admin, :first_name, :has_key, :last_name, :location_id, :passion, :phone, :roll, :shirt_size

  belongs_to :location
  has_many :offerings

  def full_name
      first_name + " " + last_name
  end
end
