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

template node['bp-percona']['my_cnf'] do
  source 'my.cnf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

case node['platform_family']
when 'debian'
  include_recipe 'apt'
  apt_repository 'percona' do
    uri 'http://repo.percona.com/apt'
    distribution node['lsb']['codename'] == 'jessie' ? 'wheezy' : node['lsb']['codename']
    components ['main']
    keyserver 'keys.gnupg.net'
    key '1C4CBDCDCD2EFD2A'
    notifies :run, 'execute[set_on_hold]', :immediately
  end

  execute 'set_on_hold' do
    command 'echo "libmysqlclient18.1 hold" | dpkg --set-selections'
    user 'root'
    action :nothing
    only_if { node['lsb']['codename'] == 'wheezy' }
  end
when 'rhel'
  include_recipe 'yum'
  yum_repository 'percona' do
    description node['bp-percona']['yum']['description']
    baseurl node['bp-percona']['yum']['baseurl']
    gpgkey node['bp-percona']['yum']['gpgkey']
    gpgcheck node['bp-percona']['yum']['gpgcheck']
    sslverify node['bp-percona']['yum']['sslverify']
    action :create
  end
end
