require_relative '../spec_helper'

describe 'homebrew::install_formulas' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.10') do |node|
      node.normal['homebrew']['formulas'] = %w(pstree wget)
    end.converge(described_recipe)
  end

  before do
    stub_command('which git').and_return('/usr/local/bin/git')
  end

  it 'installs homebrew' do
    expect(chef_run).to include_recipe('homebrew')
  end

  it 'package-installs each recipe' do
    expect(chef_run).to install_package('pstree')
    expect(chef_run).to install_package('wget')
  end

  context 'requesting a specific version' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.10') do |node|
        node.normal['homebrew']['formulas'] = [{ name: 'pstree', version: '9.9.9' }]
      end.converge(described_recipe)
    end

    it 'package-installs the requested version' do
      expect(chef_run).to install_package('pstree').with(version: '9.9.9')
    end
  end

  context 'requesting a HEAD version' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.10') do |node|
        node.normal['homebrew']['formulas'] = [{ name: 'pstree', head: true }]
      end.converge(described_recipe)
    end

    it 'package-installs the HEAD of the formula' do
      expect(chef_run).to install_package('pstree').with(options: '--HEAD')
    end
  end
end
