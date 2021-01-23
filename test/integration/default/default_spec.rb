describe command('brew info redis --json=v1 | jq ".[].installed[0].installed_on_request"') do
  its('stdout') { should match('true') }
end

describe file('/usr/local/Caskroom/caffeine') do
  it { should be_directory }
  its('mode') { should cmp '0755' }
  it { should be_owned_by 'runner' }
end
