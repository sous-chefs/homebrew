require_relative '../spec_helper'

describe 'homebrew::install_formulas' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['homebrew']['formulas'] = %w(pstree wget)
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
end
