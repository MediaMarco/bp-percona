# Encoding: UTF-8
# Cookbook Name::       bp-percona
# Description::         Makes sure mysql chef gem is installed
# Recipe::              _prerequisites
# Author::              Thorsten Winkler (<t.winkler@bigpoint.net>)

include_recipe 'apt::default'
include_recipe 'mysql-chef_gem::default' unless `/opt/chef/embedded/bin/gem list`.include? 'mysql '

node.set['mysql']['server_root_password'] = '***'
node.set['mysql']['server_repl_password'] = '***'
node.set['mysql']['server_debian_password'] = '***'

directory '/etc/mysql' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/etc/mysql/conf.d' do
  action :delete
  recursive true
end

template '/etc/mysql/my.cnf' do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :reload, 'service[mysql]', :delayed
end

apt_repository 'percona' do
  uri          'http://repo.percona.com/apt'
  distribution node['lsb']['codename'] == 'jessie' ? 'wheezy' : node['lsb']['codename']
  components   ['main']
  keyserver    'keys.gnupg.net'
  key          '1C4CBDCDCD2EFD2A'
  notifies :run, 'execute[set_on_hold]', :immediately
end

execute 'set_on_hold' do
  command 'echo "libmysqlclient18.1 hold" | dpkg --set-selections'
  user 'root'
  action :nothing
end
