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
#  channels_count       :integer
#  sms_alertable        :boolean          default(TRUE)
#  disable_alert_reason :string(255)
#  reportable           :boolean
#
# Indexes
#
#  index_users_on_phd_id_id  (phd_id_id)
#  index_users_on_place_id   (place_id)
#

class User < ActiveRecord::Base
  has_secure_password(validations: false)
  audited

  belongs_to :place
  belongs_to :phd, class_name: 'Place', foreign_key: 'phd_id'
  belongs_to :od, class_name: 'Place', foreign_key: 'od_id'

  has_many :reports, dependent: :nullify
  has_many :channels
  has_many :alerts
  # password must be present within 6..72
  validates :place_id, presence: true, if: ->(u) { !u.admin? }

  validates :password, presence: true, on: :create
  validates :password, length: { in: 6..72}, on: :create
  validates :password, confirmation: true

  # email must be in a valid format and has unique value if it is being provided
  validates :email, email: true, if: ->(u) { u.email.present? }
  validates :email, uniqueness: true, if: ->(u) { u.email.present? }

  validates :phone, uniqueness: true, if: ->(u) { u.phone.present? }

  validates :phone, presence: {message: "Health Center user must has a phone number"}, if: ->(u) { u.place && u.place.hc?}

  validates :name, presence: true

  validates :username, presence: true
  validates :username, uniqueness: true

  ROLE_ADMIN  = 'Admin'
  ROLE_NORMAL = 'Normal'

  before_save :normalize_attrs
  before_save :set_place_tree

  attr_accessor :old_password

  def self.search phone
    phone.present? ? where(["phone LIKE ?", "%#{phone}%"]) : all
  end

  def self.by_place place_id
    users = User.order("name DESC")
    place_id.present? ? users.where(place_id: place_id) : users.all
  end

  def set_place_tree
    if self.place
      self.phd = self.place.phd
      self.od  = self.place.od
    end
  end

  def normalize_attrs
    self.role = User::ROLE_NORMAL unless self.role.present?
    self.username.downcase!
    self.phone_without_prefix = self.phone.present? ? Tel.new(self.phone).without_prefix : nil
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

  def admin?
    role == User::ROLE_ADMIN
  end

  def normal?
    role == User::ROLE_NORMAL
  end

  def sms_alertable?
    sms_alertable && phone.present?
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

  def self.find_by_address(address)
    return nil if address.nil? || address.empty?
    User.find_by(phone_without_prefix: Tel.new(address).without_prefix)
  end

  def self.hc_worker? address
    user = find_by_address(address)
    !user.nil? && user.hc_worker?
  end

  def hc_worker?
    !place.nil? && place.hc?
  end

  def self.reportable?(address)
    return nil if address.nil? || address.empty?
    user = User.find_by(phone_without_prefix: Tel.new(address).without_prefix, reportable: true)
    return user ? true : false
  end

  def reportable?
    return (place.kind_of == 'HC') ? true : false
  end

  def self.members_of(places = [])
    members = []
    places.each do |place|
      place.users.each { |user| members.push(user) unless members.include?(user) }

      place.children ? members.concat(members_of(place.children)) : members
    end
    members
  end

end
