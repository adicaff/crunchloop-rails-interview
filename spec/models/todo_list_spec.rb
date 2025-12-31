require 'rails_helper'

RSpec.describe TodoList, type: :model do
  describe 'associations' do
    it 'has many list_items' do
      association = described_class.reflect_on_association(:list_items)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      list = TodoList.new(name: nil)
      expect(list).not_to be_valid
      expect(list.errors[:name]).to include("can't be blank")
    end

    it 'is valid with a name' do
      list = TodoList.new(name: 'Test List')
      expect(list).to be_valid
    end
  end
end
