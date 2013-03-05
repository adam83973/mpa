class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :active, :address, :admin, :first_name, :has_key, :last_name, :location_id, :passion, :phone, :roll, :shirt_size

  belongs_to :location
  has_and_belongs_to_many :offerings

  def full_name
      first_name + " " + last_name
  end
end
