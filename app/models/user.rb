class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :invitable

  validates_presence_of :first_name, :last_name, :role

  # Setup accessible (or protected) attributes for your model

  attr_accessible :email, :password, :current_password, :password_confirmation, :remember_me, :offering_ids
  attr_accessible :active, :address, :admin, :first_name, :has_key, :last_name, :location_id, :passion, :phone, :role, :shirt_size, :infusion_id

  attr_accessor :current_password

  belongs_to :location
  has_many :students, :through => :offerings
  has_many :students
  has_many :experience_points
  has_and_belongs_to_many :offerings

  def full_name
      first_name + " " + last_name
  end

  def self.search(search)
    if search
       @users_search = User.where('lower(first_name) LIKE ? OR lower(last_name) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%").limit(15)
    end
  end

  def teacher?
    ["Teacher", "Teaching Assistant"].include?(self.role)
  end

  def employee?
    ["Teacher", "Teaching Assistant", "Admin"].include?(self.role)
  end

  def parent?
    ["Parent"].include?(self.role)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      user = find_by_id(row["id"]) || new
      user.attributes = row.to_hash.slice(*accessible_attributes)
      user.save!(:validate => false)
    end
  end
end
