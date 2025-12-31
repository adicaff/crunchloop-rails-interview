require 'rails_helper'

RSpec.describe TodoList, type: :model do
  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'has many list_items' do
      association = described_class.reflect_on_association(:list_items)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'validations' do
    it 'is invalid without a name' do
      list = described_class.new(name: nil)
      expect(list).not_to be_valid
      expect(list.errors[:name]).to include("can't be blank")
    end

    it 'is valid with a name and user' do
      user = User.create!(username: 'testuser', password: 'password')
      list = described_class.new(name: 'Test List', user: user)
      expect(list).to be_valid
    end
  end
end
