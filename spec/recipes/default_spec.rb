require_relative '../spec_helper'

describe 'homebrew::default' do
  context 'default user' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    before(:each) do
      allow_any_instance_of(Chef::Resource).to receive(:homebrew_owner).and_return('vagrant')
      allow_any_instance_of(Chef::Recipe).to receive(:homebrew_owner).and_return('vagrant')
      allow(File).to receive(:exist?).and_return(false)
      stub_command('which git').and_return(true)
    end

    it 'runs homebrew installation as the default user' do
      expect(chef_run).to run_execute('install homebrew').with(
        :user => 'vagrant'
      )
    end

    it 'updates homebrew from github' do
      expect(chef_run).to run_execute('update homebrew from github').with(
        :user => 'vagrant'
      )
    end
  end

  context '/usr/local/bin/brew exists' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    before(:each) do
      allow(File).to receive(:exist?).and_return(true)
      stub_command('which git').and_return(true)
    end

    it 'does not run homebrew installation' do
      expect(chef_run).to_not run_execute('install homebrew')
    end
  end

  context 'non-default, specified by attribute user' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['homebrew']['owner'] = 'alaska'
      end.converge(described_recipe)
    end

    before(:each) do
      allow(File).to receive(:exist?).and_return(false)
      stub_command('which git').and_return(true)
    end

    it 'installs homebrew as the alaska user' do
      expect(chef_run).to run_execute('install homebrew').with(
        :user => 'alaska'
      )
    end
  end

  context 'do not auto-update brew' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['homebrew']['auto-update'] = false
      end.converge(described_recipe)
    end

    before(:each) do
      stub_command('which git').and_return(true)
    end

    it 'does not manage the git package' do
      expect(chef_run).to_not install_package('git')
    end

    it 'does not update brew from github' do
      expect(chef_run).to_not run_execute('update homebrew from github')
    end
  end

  context 'conditionally manage git package' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new.converge(described_recipe)
    end

    context 'git is installed' do
      before(:each) do
        stub_command('which git').and_return(true)
      end

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
