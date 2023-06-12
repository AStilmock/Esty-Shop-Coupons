require 'rails_helper'

RSpec.describe 'External Requests' do
  it 'queries upcoming holidays from external source' do
    uri = URI('https://date.nager.at/api/v3/NextPublicHolidays/US')

    response = Net::HTTP.get(uri)

    expect(response).to be_an_instance_of(String)
  end
end