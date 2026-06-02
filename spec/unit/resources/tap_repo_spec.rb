# frozen_string_literal: true

require 'spec_helper'

describe 'homebrew_tap_repo' do
  step_into :homebrew_tap_repo
  platform 'mac_os_x', '12'

  before do
    allow(Dir).to receive(:home).and_call_original
    allow(Dir).to receive(:home).with('testuser').and_return('/Users/testuser')
    allow(File).to receive(:directory?).and_call_original
    allow(File).to receive(:directory?).with('/opt/homebrew/Library/Taps/homebrew/homebrew-services').and_return(false)
    allow_any_instance_of(HomebrewWrapper).to receive(:install_path).and_return('/opt/homebrew')
    allow_any_instance_of(HomebrewWrapper).to receive(:repository_path).and_return('/opt/homebrew')
    allow_any_instance_of(HomebrewWrapper).to receive(:owner).and_return('testuser')
  end

  context 'with default properties' do
    recipe do
      homebrew_tap_repo 'homebrew/services'
    end

    it { is_expected.to run_execute('tap homebrew/services').with(command: '/opt/homebrew/bin/brew tap homebrew/services') }
  end

  context 'with legacy full property and URL' do
    recipe do
      homebrew_tap_repo 'homebrew/services' do
        full true
        url 'https://github.com/homebrew/homebrew-services.git'
      end
    end

    it do
      is_expected.to run_execute('tap homebrew/services').with(
        command: '/opt/homebrew/bin/brew tap homebrew/services https://github.com/homebrew/homebrew-services.git'
      )
    end
  end

  context 'action :untap' do
    before do
      allow(File).to receive(:directory?).with('/opt/homebrew/Library/Taps/homebrew/homebrew-services').and_return(true)
    end

    recipe do
      homebrew_tap_repo 'homebrew/services' do
        action :untap
      end
    end

    it { is_expected.to run_execute('untap homebrew/services').with(command: '/opt/homebrew/bin/brew untap homebrew/services') }
  end
end
