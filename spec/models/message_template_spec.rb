require 'rails_helper'

RSpec.describe MessageTemplate, type: :model do
  let(:message_template) { MessageTemplate.instance }

  context 'interpolate' do
    it { expect(message_template.set_source!('').interpolate({var1: 'foo'})).to eq '' }
    it { expect(message_template.set_source!('Alert of var1: {{var1}}').interpolate({var1: 'foo'})).to eq 'Alert of var1: foo' }
    it { expect(message_template.set_source!('Alert of var1: {{var1}}, var2: {{var2}}').interpolate({var1: 'foo', var2: 'bar'})).to eq 'Alert of var1: foo, var2: bar' }
  end
end
