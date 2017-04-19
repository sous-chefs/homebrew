require 'spec_helper'

describe 'homebrew::cask' do
  context 'default user' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    before(:each) do
      allow(Homebrew).to receive(:owner).and_return('vagrant')
    end

    it 'manages the Cask Cache directory' do
      allow(Dir).to receive(:exist?).with('/Library/Caches/Homebrew').and_return(true)
      expect(chef_run).to create_directory('/Library/Caches/Homebrew/Casks').with(
        user: 'vagrant',
        mode: '775'
      )
    end
  end
end
