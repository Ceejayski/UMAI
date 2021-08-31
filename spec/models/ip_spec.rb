require 'rails_helper'

RSpec.describe Ip, type: :model do
  it {should validate_presence_of :ip_address}
  it {should belong_to :post}
end
