require 'rails_helper'

RSpec.describe ProcessRun, type: :model do
  it 'has a valid factory' do
    expect(build(:process_run)).to be_valid
  end
end
