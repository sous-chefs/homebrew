# Check both x86_64 and arm64 locations for brew
# Depending on shell setup in the box:
# InSpec commands want a full path, but this depends on arch + platform_version
# macOS default shell may be /bin/bash or /bin/zsh ... back to basics: /bin/sh
describe command('/bin/sh -c "PATH=/opt/homebrew/bin:/usr/local/bin:$PATH  brew --version"') do
  its('stdout') { should match('^Homebrew.*$') }
end

brew_prefix = command('/bin/sh -c "PATH=/opt/homebrew/bin:/usr/local/bin:$PATH  brew --prefix"').stdout.chomp
describe brew_prefix do
  it { should match('^(\/usr\/local|\/opt\/homebrew)$') }
end

describe file(brew_prefix) do
  it { should be_directory }
end

brew_caskroom = command('/bin/sh -c "PATH=/opt/homebrew/bin:/usr/local/bin:$PATH  brew --caskroom"').stdout.chomp
describe brew_caskroom do
  it { should match('^(\/usr\/local|\/opt\/homebrew)/Caskroom$') }
end

describe file(brew_caskroom) do
  it { should be_directory }
end

describe package('redis') do
  it { should be_installed }
end

describe package('jq') do
  it { should be_installed }
end

# CI agnostic caskroom owner check
# InSpec may be running commands w/sudo
ci_user = command('whoami').stdout.chomp
if ci_user == 'root'
  ci_user = command("/bin/sh -c 'echo $SUDO_USER'").stdout.chomp
end
describe file("#{brew_caskroom}/caffeine") do
  it { should be_directory }
  its('mode') { should cmp '0755' }
  it { should be_owned_by ci_user }
end
