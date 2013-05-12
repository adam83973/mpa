class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name, :last_name, :location, :role

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :active, :address, :admin, :first_name, :has_key, :last_name, :location_id, :passion, :phone, :role, :shirt_size

  belongs_to :location
  has_many :offerings
  has_many :students, :through => :offerings
  has_many :students
  has_many :experience_points

  def full_name
      first_name + " " + last_name
  end

  def self.search(search)
    if search
       @users_search = User.where('first_name LIKE ? OR last_name LIKE ?', "%#{search}%", "%#{search}%").limit(10)
    end
  end

  def students_by_offering
    offerings.each do |x|

    end
  end
end
