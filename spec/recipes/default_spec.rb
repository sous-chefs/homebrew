require 'spec_helper'

describe 'homebrew::default' do
  before do
    allow(Homebrew).to receive(:exist?).and_return(true)
    allow(Homebrew).to receive(:owner).and_return('vagrant')
    stub_command('which git').and_return(true)
  end

  context 'default user' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    before do
      allow(Homebrew).to receive(:exist?).and_return(false)
    end

    it 'runs homebrew installation as the default user' do
      expect(chef_run).to run_execute('install homebrew').with(
        user: 'vagrant'
      )
    end

    it 'updates homebrew from github' do
      expect(chef_run).to run_execute('update homebrew from github').with(
        user: 'vagrant'
      )
    end
  end

  context '/usr/local/bin/brew exists' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef12HomebrewUser).to receive(:find_homebrew_uid).and_return(Process.uid)
    end

    it 'does not run homebrew installation' do
      expect(chef_run).to_not run_execute('install homebrew')
    end
  end

  context 'do not auto-update brew' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['homebrew']['auto-update'] = false
      end.converge(described_recipe)
    end

    it 'does not manage the git package' do
      expect(chef_run).to_not install_package('git')
    end

    it 'does not update brew from github' do
      expect(chef_run).to_not run_execute('update homebrew from github')
    end
  end

  context 'disables brew analytics' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['homebrew']['enable-analytics'] = false
      end.converge(described_recipe)
    end

    it 'turns off analytics' do
      expect(chef_run).to_not run_execute('set analytics')
    end
  end

  context 'conditionally manage git package' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    context 'git is installed' do
      it 'does not install git' do
        expect(chef_run).to_not install_package('git')
      end
    end

    context 'git is not installed' do
      before(:each) do
        stub_command('which git').and_return(false)
      end

      it 'installs git' do
        expect(chef_run).to install_package('git')
      end
    end
  end
end
