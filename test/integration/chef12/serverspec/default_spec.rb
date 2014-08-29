require 'spec_helper'

describe 'brew package for redis' do
  describe command('/usr/local/bin/brew info redis --json=v1') do
    # the JSON output is awkward to parse here, but it's
    # cross-platform-version, since the formula may be installed as a
    # source or from bottle depending on the version of OS X.
    its(:stdout) { should match('"installed":\[{"version":')}
  end

  describe command(%Q[chef-apply -l info -e 'Chef::Log.info(Chef::Platform.find(:mac_os_x, nil)[:package])']) do
    its(:stdout) { should match('INFO: Chef::Provider::Package::Homebrew') }
  end
end
