# == Schema Information
#
# Table name: variables
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :string(255)
#  verboice_id         :integer
#  verboice_name       :string(255)
#  verboice_project_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Variable, type: :model do
  describe 'save_from_params' do
    let(:attrs) do  
      { project: "24",
        variable: {"0"=>"availablability", 
                   "1"=>"age",
                   "2"=>"number_bed",
                   "3"=>"number_doc",
                   "4" => "location",
                   "5" => "" },

        project_variable_id: { "0"=>"65",
                               "1"=>"66",
                               "2"=>"67",
                               "3"=>"68",
                               "4"=>"",
                               "5"=>"70" },

        project_variable_name: { "0"=>"available",
                                 "1"=>"age",
                                 "2"=>"bed",
                                 "3"=>"doctor",
                                 "4"=>"",
                                 "5"=>"contact"}
        }
      end

    before(:each) do
      create(:variable, verboice_project_id: 24, verboice_id: 65, verboice_name: "total", name: 'ppp')
      create(:variable, verboice_project_id: 23, verboice_id: 67, verboice_name: "bed")
    end

    it 'create 3 new variables' do
      count_variable = Variable.count
      Variable.save_from_params(attrs)

      expect(Variable.count).to eq count_variable+3

      variable_attr1 = {name: "age", description: "age", verboice_id: 66, verboice_name: "age", verboice_project_id: 24 }
      variable_attr2 = {name: "number_bed", description: "number_bed", verboice_id: 67, verboice_name: "bed", verboice_project_id: 24 }
      variable_attr3 = {name: "number_doc", description: "number_doc", verboice_id: 68, verboice_name: "doctor", verboice_project_id: 24 }

      variables = Variable.last(3)

      expect_variable_contains_hash(variables[0], variable_attr1)
      expect_variable_contains_hash(variables[1], variable_attr2)
      expect_variable_contains_hash(variables[2], variable_attr3)
    end

    it 'update one existing variable' do
      Variable.save_from_params(attrs)
      variable_update = Variable.where(verboice_project_id: 24, verboice_id: 65).first
      variable_update_attrs = {name: "availablability", description: "availablability", verboice_id: 65, verboice_name: "available", verboice_project_id: 24}
      expect_variable_contains_hash(variable_update, variable_update_attrs)
    end
  end

  def expect_variable_contains_hash(variable, hash_attrs)
    hash_attrs.each do |key, value|
      expect(variable.try(key)).to eq value
    end
  end
end
