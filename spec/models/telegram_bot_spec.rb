# == Schema Information
#
# Table name: telegram_bots
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  username   :string(255)
#  enabled    :boolean          default(FALSE)
#  actived    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe TelegramBot, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
