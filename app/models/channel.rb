# == Schema Information
#
# Table name: channels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  user_id    :integer
#  password   :string(255)
#  setup_flow :string(255)
#  is_enable  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_channels_on_user_id  (user_id)
#

class Channel < ActiveRecord::Base
  belongs_to :user, counter_cache: true

  SETUP_FLOW_BASIC    = 'Basic'
  SETUP_FLOW_ADVANCED = 'Advanced'
  SETUP_FLOW_GLOBAL = 'National'

  validates :name, uniqueness: { scope: :user_id}

  validates :password, presence: true, length: {minimum: 4, maximum: 6}, if: ->(u) { u.advanced_setup? }

  validates :ticket_code, :presence => {:on => :create},  if: ->(u) { u.basic_setup? }
  attr_accessor :ticket_code
  attr_accessor :nuntium_connection

  def basic_setup?
    self.setup_flow == Channel::SETUP_FLOW_BASIC
  end

  def advanced_setup?
    self.setup_flow == Channel::SETUP_FLOW_ADVANCED
  end

  def global_setup?
    self.setup_flow == Channel::SETUP_FLOW_GLOBAL
  end

  def gen_password
    self.password = SecureRandom.base64(6) if self.password.blank?
  end

  def self.disable_other except_id
    where(['id != ? ', except_id ]).update_all({is_enable: false })
  end

  def update_state(state)
    self.is_enable = state
    if self.save && (state == true || state == 'true' || state == "1" || state == 1)
      # Channel.where(['user_id = ? AND id != ?', self.user_id, self.id ]).update_all({is_enable: false })
    end
  end

  def is_connected?
    Sms.instance.nuntium.channel(self.name)[:connected]
  end

end
