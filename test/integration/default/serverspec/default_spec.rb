require 'spec_helper'

describe 'homebrew installation' do
  describe command('sudo -u vagrant /usr/local/bin/brew info redis --json=v1') do
    # the JSON output is awkward to parse here, but it's
    # cross-platform-version, since the formula may be installed as a
    # source or from bottle depending on the version of OS X.
    its(:stdout) { should match('"installed":\[{"version":') }
  end

  describe command(%[chef-apply -e 'Chef::Log.info(Chef::Platform.find(:mac_os_x, nil)[:package]) -l info']) do
    its(:stdout) { should match('INFO: Chef::Provider::Package::Homebrew') }
  end

  describe file('/usr/local/Caskroom/caffeine') do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'vagrant' }
  end

  describe file('/usr/local/Homebrew/Library/Taps/homebrew/homebrew-games/.git') do
    it { should be_directory }
    it { should be_owned_by 'vagrant' }
  end
end
