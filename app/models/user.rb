# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  username             :string(255)
#  name                 :string(255)
#  password_digest      :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  email                :string(255)
#  phone                :string(255)
#  role                 :string(255)
#  place_id             :integer
#  phone_without_prefix :string(255)
#  phd_id_id            :integer
#  phd_id               :integer
#  od_id                :integer
#
# Indexes
#
#  index_users_on_phd_id_id  (phd_id_id)
#  index_users_on_place_id   (place_id)
#

class User < ActiveRecord::Base
  has_secure_password(validations: false)

  belongs_to :place
  has_many :reports

  # password must be present within 6..72
  validates :place_id, presence: true

  validates :password, presence: true, on: :create
  validates :password, length: { in: 6..72}, on: :create
  validates :password, confirmation: true

  # email must be in a valid format and has unique value if it is being provided
  validates :email, email: true, if: ->(u) { u.email.present? }
  validates :email, uniqueness: true, if: ->(u) { u.email.present? }

  validates :phone, uniqueness: true, if: ->(u) { u.phone.present? }

  validates :phone, presence: {message: "Health Center user must has a phone number"}, if: ->(u) { u.place && u.place.is_kind_of_hc?}

  validates :name, presence: true

  validates :username, presence: true
  validates :username, uniqueness: true

  ROLE_ADMIN  = 'Admin'
  ROLE_NORMAL = 'Normal'

  before_save :normalize_attrs

  attr_accessor :old_password

  def self.search phone
    @users = where("1=1")
    @users = where(["phone LIKE ?", "%#{phone}%"]) unless phone.blank?
    @users
  end

  def self.by_place place_id
    users = User.order("name DESC").all
    if(place_id.present?)
      users = users.where(place_id: place_id)
    end
    users
  end

  def normalize_attrs
    self.role = User::ROLE_NORMAL unless self.role.present?
    self.username.downcase!
    self.phone_without_prefix = Tel.new(self.phone).without_prefix if self.phone.present?
  end

  def self.authenticate(username, password)
    user = User.find_by!(username: username.downcase)
    user.authenticate(password)
  rescue ActiveRecord::RecordNotFound
    false
  end

  def self.visible_roles
    [ROLE_NORMAL, ROLE_ADMIN]
  end

  def is_admin?
    role == User::ROLE_ADMIN
  end

  def change_password old_password, new_password, confirm
    if self.authenticate(old_password)
      self.password = new_password
      self.password_confirmation = confirm
      save
    else
      errors.add(:old_password, 'does not matched')
      false
    end
  end

  def self.hc_worker? phone_number
    phone_without_prefix = Tel.new(phone_number).without_prefix
    user = User.find_by(phone_without_prefix: phone_without_prefix)
    !user.nil? && user.place && user.place.is_kind_of_hc?
  end

end
