class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
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
    if self.role
      ["Teacher", "Teaching Assistant", "Admin"].include?(self.role)
    end
  end

  def parent?
    ["Parent"].include?(self.role)
  end

  def last_payment
    if self.infusion_id && self.role == 'Parent'
      invoice = Infusionsoft.data_query_order_by('Invoice', 1, 0, {:ContactId => self.infusion_id}, [:Id, :InvoiceTotal, :TotalPaid, :TotalDue, :Description, :DateCreated, :RefundStatus, :PayStatus], "Id", false)
      invoice.each do |i|
        if i["PayStatus"] == 0
          i["Status"] = "<span class='label label-important'>Unpaid</span>"
        elsif i["RefundStatus"] == 1
          i["Status"] = "<span class='label label-warning'>Partial Refund</span>"
        elsif i["RefundStatus"] == 2
          i["Status"] = "<span class='label label-warning'>Full Refund</span>"
        else
          i["Status"] = "<span class='label label-success'>Paid</span>"
        end
      end
      unless invoice == nil
        payment_details = Hash.new
        payment_details.merge!( pay_date: invoice[0]["DateCreated"].to_date().strftime("%b-%d-%y") )
        payment_details.merge!( total_paid: invoice[0]["TotalPaid"] )
        payment_details.merge!( status: invoice[0]["Status"] )
        return payment_details
      end
    else
      return nil
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      user = find_by_id(row["id"]) || new
      user.attributes = row.to_hash.slice(*accessible_attributes)
      user.save!(:validate => false)
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |user|
        csv << user.attributes.values_at(*column_names)
      end
    end
  end
end
