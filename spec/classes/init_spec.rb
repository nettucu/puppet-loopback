require 'spec_helper'
describe 'loopback' do

  context 'with defaults for all parameters' do
    it { should contain_class('loopback') }
  end
end
