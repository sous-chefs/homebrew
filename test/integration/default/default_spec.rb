describe command('sudo -u vagrant /usr/local/bin/brew info redis --json=v1') do
  # the JSON output is awkward to parse here, but it's
  # cross-platform-version, since the formula may be installed as a
  # source or from bottle depending on the version of OS X.
  its(:stdout) { should match('"installed":\[{"version":') }
end

describe file('/usr/local/Caskroom/caffeine') do
  it { should be_directory }
  it { should be_mode 0755 }
  it { should be_owned_by 'vagrant' }
end

describe file('/usr/local/Homebrew/Library/Taps/homebrew/homebrew-nginx/.git') do
  it { should be_directory }
  it { should be_owned_by 'vagrant' }
end

describe command('sudo -u vagrant bash -c \'REPO=$(brew --repo homebrew/bundle); [ -f "${REPO}/$(git -C "${REPO}" rev-parse --git-dir)/shallow" ] && echo true || echo false\'') do
  its(:stdout) { should match('false') }
end
