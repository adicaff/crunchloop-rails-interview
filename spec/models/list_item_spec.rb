require 'rails_helper'

RSpec.describe ListItem, type: :model do
  describe 'associations' do
    it 'belongs to todo_list' do
      association = described_class.reflect_on_association(:todo_list)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    it 'is invalid without a description' do
      item = ListItem.new(description: nil)
      expect(item).not_to be_valid
      expect(item.errors[:description]).to include("can't be blank")
    end

    it 'is valid with a description' do
      todo_list = TodoList.create(name: 'Test List')
      item = ListItem.new(description: 'Test Item', todo_list: todo_list)
      expect(item).to be_valid
    end
  end
end
