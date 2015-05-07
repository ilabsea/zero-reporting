class User < ActiveRecord::Base
  has_secure_password(validations: false)

  belongs_to :place

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

  before_save :clean_user_name

  attr_accessor :old_password


  def validate_phone_for_hc_user
    if self.place.is_kind_of_hc? && !self.phone.present?
      errors.add(:phone, "Health Center user must has a phone number")
    end
  end

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

  def clean_user_name
    self.role = User::ROLE_NORMAL unless self.role.present?
    self.username.downcase!
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

end