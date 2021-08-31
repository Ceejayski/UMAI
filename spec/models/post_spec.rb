require 'rails_helper'

RSpec.describe Post, type: :model do
  it 'should have a valid fatory' do
    post = build(:post)
    expect(post).to be_valid
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:content) }
  it { should belong_to :user }
end
