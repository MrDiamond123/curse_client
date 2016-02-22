require 'spec_helper'

describe CurseClient do
  it 'has a version number' do
    expect(CurseClient::VERSION).not_to be nil
  end
end
