require_relative '../spec_helper'

describe 'homebrew::cask' do
  context 'default user' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    before(:each) do
      allow_any_instance_of(Chef::Resource).to receive(:homebrew_owner).and_return('vagrant')
    end

    it 'updates homebrew cask as vagrant' do
      expect(chef_run).to run_execute('update homebrew cask from github').with(
        :user => 'vagrant'
      )
    end

    it 'manages the homebrew-cask directory' do
      expect(chef_run).to create_directory('/opt/homebrew-cask').with(
        :user => 'vagrant',
        :mode => 00775
      )
    end

    it 'manages the Caskroom directory' do
      expect(chef_run).to create_directory('/opt/homebrew-cask/Caskroom').with(
        :user => 'vagrant',
        :mode => 00775
      )
    end
  end

  context 'non-default, specified by attribute user' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['homebrew']['owner'] = 'alaska'
      end.converge(described_recipe)
    end

    it 'updates homebrew cask as alaska' do
      expect(chef_run).to run_execute('update homebrew cask from github').with(
        :user => 'alaska'
      )
    end

    it 'manages the homebrew-cask directory' do
      expect(chef_run).to create_directory('/opt/homebrew-cask').with(
        :user => 'alaska',
        :mode => 00775
      )
    end

    it 'manages the Caskroom directory' do
      expect(chef_run).to create_directory('/opt/homebrew-cask/Caskroom').with(
        :user => 'alaska',
        :mode => 00775
      )
    end
  end
end
