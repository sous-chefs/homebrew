# Policyfile.rb - Describe how you want Chef Infra Client to build your system.

name 'homebrew'

# Where to find external cookbooks:
default_source :supermarket

# run_list: chef-client will run these recipes in the order specified.
run_list 'test::default'

# Specify a custom source for a single cookbook:
cookbook 'homebrew', path: '.'
cookbook 'test', path: './test/cookbooks/test'
