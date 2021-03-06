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

node.set_unless['bp-percona']['server-id'] = rand(65_536 - 10_000) + 10_000

directory '/etc/mysql' do
  owner 'root'
  group 'root'
  mode '0755'
end

directory '/etc/mysql/conf.d' do
  action :delete
  recursive true
end

[node['bp-percona']['log-error'], node['bp-percona']['slow-query-log-file']].each do |dir|
  directory File.dirname(dir) do
    owner node['bp-percona']['user']
    group 'root'
    mode '0755'
  end
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
    uri node['bp-percona']['apt']['mirror']
    distribution node['lsb']['codename'] == 'jessie' ? 'wheezy' : node['lsb']['codename']
    components node['bp-percona']['apt']['components']
    keyserver node['bp-percona']['apt']['keyserver']
    key node['bp-percona']['apt']['key']
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
