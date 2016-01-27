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
  audited

  belongs_to :place
  belongs_to :phd, class_name: 'Place', foreign_key: 'phd_id'
  belongs_to :od, class_name: 'Place', foreign_key: 'od_id'

  has_many :reports, dependent: :nullify

  # password must be present within 6..72
  validates :place_id, presence: true, if: ->(u) { !u.is_admin? }

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
  before_save :set_place_tree

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

  def is_admin?
    role == User::ROLE_ADMIN
  end

  def is_normal?
    role == User::ROLE_NORMAL
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

  def self.decode_and_validate_user_csv(string)
    csv = CSV.parse(string)
    errors = []
    datas = []
    index = 0
    csv.slice!(0)
    csv.each do |row|
      valid = validate_row(index, row, csv)
      unless valid[:status]
        row.push(valid[:errors])
      end
      datas.push row
      index = index + 1
    end
    return {:data => datas}
  end

  def self.validate_row(index, row, csv)
    if row[4].strip.present? and row[5].strip.present? and row[4] != row[5]
      errors.push({:type => 'not_match', :field => 'password'})
    elsif row[4].strip.empty? or row[5].strip.empty?
      errors.push({:type => 'missing', :field => 'password'})
    end
    if row[6].strip.present?
      place = Place.find_by_code(row[6])
      unless place
        errors.push({:type => 'unknown', :field => 'place'})
      else
        row[6] = "#{place.name}(#{place.code}) - #{place.kind_of}"
      end
    elsif row[4].strip.empty? or row[5].strip.empty?
      errors.push({:type => 'missing', :field => 'place'})
    end
    errors = calculateError(csv, row, index)

    list_errors = generateErrorText(errors)

    if list_errors.size > 0
      return {:status => false, errors: list_errors}
    else
      return {:status => true}
    end
  end

  def self.calculateError(csv, row, index)
    errors = []
    i = 0
    errors.push({:type => 'duplicate', :field => 'login', :index => nil}) if User.find_by_username(row[0])
    # errors.push({:type => 'duplicate', :field => 'email', :index => nil}) if User.find_by_email(row[2])
    errors.push({:type => 'duplicate', :field => 'phone', :index => nil}) if User.find_by_phone(row[3])
    csv.each do |value|
      if i < index.to_i
        if row[0] == value[0]
          errors.push({:type => 'duplicate', :field => 'login', :index => (i+1)})
        elsif row[0].strip.empty?
          errors.push({:type => 'missing', :field => 'login'})
        end
        # if row[2] == value[2]
        #   errors.push({:type => 'duplicate', :field => 'email', :index => (i+1)})
        # elsif row[2].strip.empty?
        #   errors.push({:type => 'missing', :field => 'email'})
        # end
        if row[3] == value[3]
          errors.push({:type => 'duplicate', :field => 'phone', :index => (i+1)})
        elsif row[3].strip.empty?
          errors.push({:type => 'missing', :field => 'phone'})
        end
      end
      i = i + 1
    end
    return errors;
  end

  def self.generateErrorText(errors)
    list_errors = []
    errors.each do |error|
      case error[:field]
      when 'login'
        if error[:type] == 'duplicate'
          list_errors.push(generateDuplicateErrrorText(error[:index], "login"))
        elsif error[:type] == 'missing'
          list_errors.push(generateMissingErrrorText("login"))
        end
      when 'email'
        if error[:type] == 'duplicate'
          list_errors.push(generateDuplicateErrrorText(error[:index], "email"))
        elsif error[:type] == 'dupmissinglicate'
          list_errors.push(generateMissingErrrorText("email"))
        end
      when 'phone'
        if error[:type] == 'duplicate'
          list_errors.push(generateDuplicateErrrorText(error[:index], "phone number"))
        elsif error[:type] == 'missing'
          list_errors.push(generateMissingErrrorText("phone number"))
        end
      when 'password'
        if error[:type] == 'not_match'
          list_errors.push("Password not match on row #{index}")
        elsif error[:type] == 'missing'
          list_errors.push("Password or confirmation password is missing")
        end
      when 'place'
        if error[:type] == 'missing'
          list_errors.push("Place is missing")
        elsif error[:type] == 'unknown'
          list_errors.push("Place is unknown")
        end
      end
    end
    return list_errors
  end

  def self.generateDuplicateErrrorText(index, field)
    if index
      return "Duplicated #{field} value on row #{index}."
    else
      return "Duplicated #{field} with existing user #{field}."
    end
  end

  def self.generateMissingErrrorText(field)
    return "Missing #{field} value."
  end

  def self.decode_and_save_user_csv(string)
    csv = CSV.parse(string)
    datas = []
    csv.slice!(0)
    csv.each do |row|
      datas.push row
      place = Place.find_by_code(row[6].strip)
      phd_id = place.phd.id
      od_id = nil
      od_id = place.od.id if place.od
      User.create!(
          username: row[0],
          name: row[1],
          email: row[2],
          phone: row[3],
          role: "Normal",
          place_id: place.id,
          password: row[4],
          password_confirmation: row[5],
          phd_id: phd_id,
          od_id: od_id
      )
    end
    return {:data => datas}
  end
end
