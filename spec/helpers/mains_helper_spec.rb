require 'rails_helper'

RSpec.describe MainsHelper, type: :helper do
  describe '#active_first_item' do
    it 'first item in @photos' do
      expect(active_first_item(0)).to eq ('active')
    end

    it 'not first item in @photos' do
      expect(active_first_item(1)).not_to eq ('active')
      expect(active_first_item(1)).to eq (nil)
    end
  end
end
