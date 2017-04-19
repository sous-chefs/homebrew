require 'spec_helper'

describe 'homebrew::install_formulas' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal['homebrew']['formulas'] = %w(pstree wget)
    end.converge(described_recipe)
  end

  before do
    stub_command('which git').and_return('/usr/local/bin/git')
    allow(Homebrew).to receive(:owner).and_return('vagrant')
    allow(Homebrew).to receive(:exist?).and_return(true)
  end

  it 'installs homebrew' do
    expect(chef_run).to include_recipe('homebrew')
  end

  it 'package-installs each recipe' do
    expect(chef_run).to install_package('pstree')
    expect(chef_run).to install_package('wget')
  end

  context 'requesting a specific version' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['homebrew']['formulas'] = [{ name: 'pstree', version: '9.9.9' }]
      end.converge(described_recipe)
    end

    it 'package-installs the requested version' do
      expect(chef_run).to install_package('pstree').with(version: '9.9.9')
    end
  end

  context 'requesting a HEAD version' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['homebrew']['formulas'] = [{ name: 'pstree', head: true }]
      end.converge(described_recipe)
    end

    it 'package-installs the HEAD of the formula' do
      expect(chef_run).to install_package('pstree').with(options: eq('--HEAD').or(eq(%w(--HEAD))))
    end
  end
end
